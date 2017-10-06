//
//  BuyViewController.swift
//  EduardoWashington
//
//  Created by Eduardo Wallace on 05/10/2017.
//  Copyright © 2017 Eduardo Wallace. All rights reserved.
//

import UIKit
import CoreData

class BuyViewController: UIViewController {
    
    @IBOutlet weak var tfTotalUS: UILabel!
    @IBOutlet weak var tfTotalRS: UILabel!
    
    var dataSource: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProducts()
        sumProductsDolars()
        sumProductsReal()
    }
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sumProductsDolars() {
        var sumDolar: Double = 0.0
        for product in dataSource {
             sumDolar += product.amount;
        }
        tfTotalUS.text = "\(sumDolar)"
    }
    
    func sumProductsReal() {
        var sumReal: Double = 0.0
        for product in dataSource {
            if product.isCard { //OBS falta converter o dolar pra real
                let IOF = product.state?.iof ?? 0
                let sumIOF = (product.amount * IOF) / 100 //OBS: aplicar regra pra calcular IOF
                sumReal += product.amount + sumIOF
            } else {
                sumReal += product.amount
            }
        }
        tfTotalRS.text = "\(sumReal)"
    }

}
