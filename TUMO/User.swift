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

    convenience init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let name = dictionary["givenName"] as? String else {
                return nil
        }
        self.init(id: id, name: name)
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

    static func authenticate(with credential: Credential, completion: @escaping (User?) -> Void) {

        /*
         The following is another example of making an HTTP Request.
         Replace it with the real TUMO Authentication API call.
         */

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
                return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let path = Bundle.main.path(forResource: "mockUser", ofType: "json"),
                let dataString = try? String(contentsOfFile: path),
                let data = dataString.data(using: .utf8) else {
                    return completion(nil)
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let userDict = (json as? [[String: Any]])?.first ?? [:]
                let user = User(dictionary: userDict)
                completion(user)
            } catch {
                print(error)
            }
        }.resume()
    }
}

struct Credential {
    let username: Username
    let password: Password
}

struct Username {
    let rawValue: String

    init?(rawValue: String) {
        self.rawValue = rawValue
    }
}


struct Password {
    let rawValue: String

    init?(rawValue: String) {
        self.rawValue = rawValue
    }
}
