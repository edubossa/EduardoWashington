//
//  FormatterUtils.swift
//  EduardoWashington
//
//  Created by Eduardo Wallace on 08/10/2017.
//  Copyright © 2017 Eduardo Wallace. All rights reserved.
//

import Foundation

enum LocaleType: String {
    case US = "en_US"
    case BR = "pt_BR"
}

class FormatterUtils {
    
    static func format(value: Double, localeType: LocaleType) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: localeType.rawValue)
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: value as NSNumber)!
    }
    
}
