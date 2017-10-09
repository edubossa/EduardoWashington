//
//  ShopTableViewController.swift
//  EduardoWashington
//
//  Created by Eduardo Wallace on 30/09/17.
//  Copyright © 2017 Eduardo Wallace. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ShopTableViewController: UITableViewController {
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    var fetchedResultController: NSFetchedResultsController<Product>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        label.textColor = .black
        
        loadProducts()
    }
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "edit" {
            let vc = segue.destination as! ProductViewController
            vc.product = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }
    
    //Método que define a célula que será apresentada em cada linha
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopTableViewCell
        let product = fetchedResultController.object(at: indexPath)
        cell.tfProduct.text = product.name
        cell.tfState.text = product.state?.name
        cell.tfAmount.text = FormatterUtils.format(value: product.amount, localeType: .US)
        if let image = product.image as? UIImage {
            cell.ivImage.image = image
        } else {
            cell.ivImage.image = nil
        }
        return cell
    }
    

} //FIM CLASSE


// MARK: - NSFetchedResultsControllerDelegate
extension ShopTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

