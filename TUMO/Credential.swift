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
        // Insert validation code
        self.rawValue = rawValue
    }
}

struct Password {
    let rawValue: String

    init?(rawValue: String) {
        // Insert validation code
        self.rawValue = rawValue
    }
}
