//
//  UIViewController+CoreData.swift
//  EduardoWashington
//
//  Created by Eduardo Wallace on 05/10/2017.
//  Copyright © 2017 Eduardo Wallace. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}   
