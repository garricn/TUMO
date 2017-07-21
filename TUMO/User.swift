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
    let username: String
    let password: String

    static let DocumentsDirectory: URL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")

    static var unarchived: User? {
        let file = User.ArchiveURL.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: file) as? User
    }
    
    private static var mockResourceName: String {
        let languageCode = NSLocale.autoupdatingCurrent.languageCode!
        switch languageCode {
        case "hy":
            return "mockUsers-hy"
        default:
            return "mockUsers-en"
        }
    }
    
    private static var mockUsersData: Data {
        let path = Bundle.main.path(forResource: mockResourceName, ofType: "json")!
        let dataString = try! String(contentsOfFile: path)
        return dataString.data(using: .utf8)!
    }

    init(id: String, name: String, workshops: [Workshop?], password: String, username: String) {
        self.id = id
        self.name = name
        self.workshops = workshops as! [Workshop]
        self.username = username
        self.password = password
    }

    convenience init?(dictionary: [String: Any]) {
        guard let id = dictionary[.id] as? String,
            let name = dictionary[.giveName] as? String,
            let username = dictionary[.username] as? String,
            let password = dictionary[.password] as? String,
            let workshopDicts = dictionary[.workshops] as? [[String: Any]] else {
                return nil
        }

        let workshops = workshopDicts.flatMap(Workshop.init)
        self.init(id: id, name: name, workshops: workshops, password: password, username: username)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: .id) as? String,
            let name = aDecoder.decodeObject(forKey: .name) as? String,
            let username = aDecoder.decodeObject(forKey: .username) as? String,
            let password = aDecoder.decodeObject(forKey: .password) as? String,
            let workshops = aDecoder.decodeObject(forKey: .workshops) as? [Workshop] else {
                return nil
        }
        

        self.init(id: id, name: name, workshops: workshops, password: password, username: username)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: .id)
        aCoder.encode(name, forKey: .name)
        aCoder.encode(workshops, forKey: .workshops)
        aCoder.encode(username, forKey: .username)
        aCoder.encode(password, forKey: .password)
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

    enum AuthenticationError: Error {
        case invalidPassword
        case invalidUsernameAndPassword
        case unknown
    }
    
    static func authenticate(with credential: Credential, completion: @escaping (User?, AuthenticationError?) -> Void) {

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

            do {
                let json = try JSONSerialization.jsonObject(with: mockUsersData, options: .allowFragments)
                let usersDict = json as? [[String: Any]] ?? []
                let _users = usersDict.flatMap(User.init)
                
                // Fake authentication
                for user in _users {
                    if user.username == credential.username.rawValue
                        && user.password == credential.password.rawValue {
                        completion(user, nil)
                        return
                    } else if(user.username == credential.username.rawValue){
                        
                        completion(nil, .invalidPassword)
                        return
                    }

                }
                
                // If no matching credentials then call completion with nil to fake invalid authentication
                completion(nil, .invalidUsernameAndPassword)
                
            } catch {
                completion(nil, .unknown)
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

            do {
                let json = try JSONSerialization.jsonObject(with: mockUsersData, options: .allowFragments)
                let usersDict = json as? [[String: Any]] ?? []
                // create all users from json
                let users = usersDict.flatMap(User.init)
                // find matching user
                let matchingUser = users.first(where: { $0.id == user.id })
                // return that users workshops
                if let workshops = matchingUser?.workshops {
                    completion(workshops)
                } else {
                    completion(nil)
                }
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
    static let username = "username"
    static let password = "password"
}
