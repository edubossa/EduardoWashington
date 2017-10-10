//
//  SettingsViewController.swift
//  EduardoWashington
//
//  Created by Eduardo Wallace on 05/10/2017.
//  Copyright © 2017 Eduardo Wallace. All rights reserved.
//

import UIKit
import CoreData

enum StateType {
    case add
    case edit
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tfDolarQuotation: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var isFieldStateRequired: Bool = false
    var isFieldIOFRequired: Bool = false
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    
    var dataSource: [State] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label.text = "Lista de estados vazia"
        label.textAlignment = .center
        label.textColor = .black
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfDolarQuotation.text = UserDefaults.standard.string(forKey: "dollarQuotation") ?? "3.2"
        tfIOF.text = UserDefaults.standard.string(forKey: "IOF") ?? "6.38"
        loadStates()
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(type: StateType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if self.isFieldStateRequired {
                self.createFieldRequired(field: alert.textFields![0])
            }
            if let name = state?.name {
                textField.text = name
            }
        }
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            textField.keyboardType = .decimalPad
            if self.isFieldIOFRequired {
                self.createFieldRequired(field: alert.textFields![1])
            }
            if let iof = state?.iof {
                textField.text = "\(iof)"
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            if alert.textFields![0].text!.isEmpty {self.isFieldStateRequired = true} else {self.isFieldStateRequired = false}
            if alert.textFields![1].text!.isEmpty {self.isFieldIOFRequired = true} else {self.isFieldIOFRequired = false}
            if alert.textFields![0].text!.isEmpty || alert.textFields![1].text!.isEmpty {
                self.showAlert(type: type, state: state)
                return
            }
            
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            state.iof = Double(alert.textFields?.last?.text ?? "") ?? 0.0
            
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (UIAlertAction) in
           self.isFieldStateRequired = false
            self.isFieldIOFRequired = false
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func createFieldRequired(field: UITextField) {
        field.placeholder = "Campo obrigatório"
        field.layer.borderColor = UIColor( red: 1.0, green: 0.0, blue:0, alpha: 1.0 ).cgColor
        field.layer.borderWidth = 1.0
    }
    
    @IBAction func addState(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
    }
    
} //End class



// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = self.dataSource[indexPath.row]
        self.showAlert(type: .edit, state: state)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [deleteAction]
    }
    
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = (dataSource.count == 0) ? label : nil
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        let state = dataSource[indexPath.row]
        cell.tfState.text = state.name
        cell.tfIOF.text = FormatterUtils.format(value: state.iof, localeType: .US)
        return cell
    }
}
