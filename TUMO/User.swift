//
//  User.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/15/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    let id: String
    let name: String

    static let DocumentsDirectory: URL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")

    static var unarchived: User? {
        let file = User.ArchiveURL.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: file) as? User
    }

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let name = aDecoder.decodeObject(forKey: "name") as? String else {
                return nil
        }

        self.init(id: id, name: name)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }

    @discardableResult static func archive(_ user: User) -> Bool {
        if NSKeyedArchiver.archiveRootObject(user, toFile: User.ArchiveURL.path) {
            return true
        } else {
            return false
        }
    }

    static func remove() {
        if FileManager.default.fileExists(atPath: User.ArchiveURL.path) {
            try? FileManager.default.removeItem(at: User.ArchiveURL)
        }
    }
}
