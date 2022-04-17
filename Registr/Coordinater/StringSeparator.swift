//
//  StringSeparator.swift
//  Registr
//
//  Created by Christoffer Detlef on 13/04/2022.
//

import SwiftUI

// This function is used to take the first letter of each word in a sentence
func stringSeparator(reason: String) -> String {
    let stringInput = reason
    let stringInputArr = stringInput.components(separatedBy:" ")
    var stringNeed = ""
    
    for string in stringInputArr {
        stringNeed += String(string.first!)
    }
    return stringNeed
}
