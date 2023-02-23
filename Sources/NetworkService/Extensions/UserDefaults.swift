//
//  UserDefaults.swift
//  
//
//  Created by Samy Mehdid on 23/2/2023.
//

import Foundation

extension UserDefaults {
    @objc dynamic var accessToken: String? {
        get { string(forKey: "accessToken") }
        set { setValue(newValue, forKey: "acceccToken") }
    }
}
