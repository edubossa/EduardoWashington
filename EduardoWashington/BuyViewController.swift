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
    var dollarQuotation: Double!
    var IOF: Double!
    
    var dataSource: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dollar =  UserDefaults.standard.string(forKey: "dollarQuotation") ?? "3.2"
        self.dollarQuotation = Double(dollar)
        let iof =  UserDefaults.standard.string(forKey: "dollarQuotation") ?? "6.38"
        IOF = Double(iof)
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
        tfTotalUS.text = FormatterUtils.format(value: sumDolar, localeType: .US)
    }
    
    func sumProductsReal() {
        var sumReal: Double = 0.0
        for product in dataSource {
            sumReal += (product.amount * dollarQuotation)
            if product.isCard {
                let IOF = product.state?.iof ?? 0
                let totalIOF = (sumReal * IOF) / 100
                sumReal += totalIOF
            }
        }
        tfTotalRS.text = FormatterUtils.format(value: sumReal, localeType: .BR)
    }

}
