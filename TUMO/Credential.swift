//
//  Credential.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/16/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import Foundation

struct Credential {
    let username: Username
    let password: Password
}

struct Username {
    let rawValue: String

    init?(rawValue: String) {
        let escapedCharacters = "\\\""
        let specialCharacters = "!@#$%^&*(){}[]~`'|:;<>,.?/-+=".appending(escapedCharacters)

        for character in specialCharacters.characters {
            if rawValue.characters.contains(character) {
                return nil
            }
        }

        if rawValue.characters.count < 5 || rawValue.characters.count > 25 {
            return nil
        }

        self.rawValue = rawValue
    }
}

struct Password {
    let rawValue: String

    init?(rawValue: String) {
        // Insert local validation code

        // Rules
            // must be greater than 6 characters
        self.rawValue = rawValue
    }
}
