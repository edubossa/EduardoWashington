//
//  ProductViewController.swift
//  EduardoWashington
//
//  Created by Eduardo Wallace on 02/10/2017.
//  Copyright © 2017 Eduardo Wallace. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var swIsCard: UISwitch!
    
    var product: Product!
    var state: State!
    var smallImage: UIImage!
    var isNewImageSelected: Bool = true
    
    //PickerView que será usado como entrada para cadastro dos estados
    var pickerView: UIPickerView!
    
    //Objeto que servirá como fonte de dados para alimentar o pickerView
    var dataSource:[State] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if product != nil {
            tfName.text = product.name
            tfState.text = product.state?.name
            tfAmount.text = "\(product.amount)"
            swIsCard.setOn(product.isCard, animated: false)
            if let image = product.image as? UIImage {
                ivImage.image = image
                isNewImageSelected = false
            }
        }
        
        loadStates()
        
        //Configuracoes pickerView
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        tfState.delegate = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)) 
        toolbar.items = [btCancel, btSpace, btDone]
        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolbar
    }
    
    func cancel() {
        tfState.resignFirstResponder()
    }
    
    func done() {
        state = dataSource[pickerView.selectedRow(inComponent: 0)]
        tfState.text = state.name
        cancel()
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func addState(_ sender: UIButton) {
        /*let state = State(context: context)
        state.name = "California"
        state.iof = 5.58
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }*/
        
    }
    
    @IBAction func register(_ sender: UIButton) {
        if product == nil {
            product = Product(context: context)
        }
        
        if tfState.text!.isEmpty || tfState.text!.isEmpty || tfAmount.text!.isEmpty || isNewImageSelected {
            let alert = UIAlertController(title: "Alerta", message: "Todos os campos são obrigatórios.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        product.name = tfName.text!
        product.state = state
        product.amount = Double(tfAmount.text!)!
        product.isCard = swIsCard.isOn
        if smallImage != nil {
            product.image = smallImage
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        if product != nil && product.name == nil {
            context.delete(product)
        }
        
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
} //fim classe

extension ProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].name
    }
}

extension ProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}

extension ProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //O método abaixo nos trará a imagem selecionada pelo usuário em seu tamanho original
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ivImage.image = smallImage
        isNewImageSelected = false
        dismiss(animated: true, completion: nil)
    }
}

//Bloqueia pro usuario nao digitar com o teclado
extension ProductViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
