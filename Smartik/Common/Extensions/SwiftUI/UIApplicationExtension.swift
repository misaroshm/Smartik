//
//  UIApplicationExtensoin.swift
//  Smartik
//
//  Created by Mariia Misarosh on 30.05.2025.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
