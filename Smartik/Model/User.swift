//
//  User.swift
//  Smartik
//
//  Created by Mariia Misarosh on 12.05.2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let fullname: String
    
    var childName: String?
    var childAge: Int?
    var avatarName: String?

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
