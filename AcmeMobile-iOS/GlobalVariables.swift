//
//  GlobalVariables.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import Foundation

func setFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "es_ES")
    formatter.currencySymbol = "€"
    return formatter
}

let FORMATTER = setFormatter()
