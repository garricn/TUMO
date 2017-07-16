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
    var workshops: [Workshop]

    static let DocumentsDirectory: URL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")

    static var unarchived: User? {
        let file = User.ArchiveURL.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: file) as? User
    }

    init(id: String, name: String, workshops: [Workshop]) {
        self.id = id
        self.name = name
        self.workshops = workshops
    }

    convenience init?(dictionary: [String: Any]) {
        guard let id = dictionary[.id] as? String,
            let name = dictionary[.giveName] as? String,
            let workshopDicts = dictionary[.workshops] as? [[String: Any]] else {
                return nil
        }

        let workshops = workshopDicts.flatMap(Workshop.init)
        self.init(id: id, name: name, workshops: workshops)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: .id) as? String,
            let name = aDecoder.decodeObject(forKey: .name) as? String,
            let workshops = aDecoder.decodeObject(forKey: .workshops) as? [Workshop] else {
                return nil
        }

        self.init(id: id, name: name, workshops: workshops)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: .id)
        aCoder.encode(name, forKey: .name)
        aCoder.encode(workshops, forKey: .workshops)
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
         The following is a fake HTTP request to mock a network call
         */

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
                return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            /*
             We're using a mock json file to populate our User data.
             Replace with real TUMO API json parsing
             */

            guard let path = Bundle.main.path(forResource: "mockUser", ofType: "json"),
                let dataString = try? String(contentsOfFile: path),
                let data = dataString.data(using: .utf8) else {
                    return completion(nil)
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let userDict = json as? [String: Any] ?? [:]
                let user = User(dictionary: userDict)
                completion(user)
            } catch {
                print(error)
            }
        }.resume()
    }

    static func fetchWorkshops(for user: User, completion: @escaping ([Workshop]?) -> Void) {

        /*
         The following is a fake HTTP request to mock a network call
         */

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            /*
             We're using a mock json file to populate our Workshop data.
             Replace with real TUMO API json parsing
             */

            guard let path = Bundle.main.path(forResource: "mockWorkshops", ofType: "json"),
                let dataString = try? String(contentsOfFile: path),
                let data = dataString.data(using: .utf8) else {
                    return completion(nil)
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let dictionaries = json as? [[String: Any]]
                let workshops = dictionaries?.flatMap(Workshop.init)
                completion(workshops)
            } catch {
                print(error)
            }
        }.resume()
    }
}

private extension String {
    static let id = "id"
    static let name = "name"
    static let giveName = "givenName"
    static let workshops = "workshops"
}
