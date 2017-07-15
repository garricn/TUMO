//
//  Workshop.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/13/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class Workshop: NSObject, NSCoding {
    let farmID: Int
    let serverID: String
    let photoID: String
    let secret: String
    let image: UIImage

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("workshops")

    static var unarchived: [Workshop]? {
        let file = Workshop.ArchiveURL.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: file) as? [Workshop]
    }

    init(farmID: Int, serverID: String, photoID: String, secret: String, image: UIImage) {
        self.farmID = farmID
        self.serverID = serverID
        self.photoID = photoID
        self.secret = secret
        self.image = image
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let serverID = aDecoder.decodeObject(forKey: "serverID") as? String,
        let photoID = aDecoder.decodeObject(forKey: "photoID") as? String,
        let secret = aDecoder.decodeObject(forKey: "secret") as? String,
            let image = aDecoder.decodeObject(forKey: "image") as? UIImage else {
                return nil
        }

        let farmID = aDecoder.decodeInteger(forKey: "farmID")

        self.init(farmID: farmID, serverID: serverID, photoID: photoID, secret: secret, image: image)
    }

    init?(json: [String: Any]){
        self.farmID = json["farm"] as? Int ?? -1
        self.serverID = json["server"] as? String ?? ""
        self.photoID = json["id"] as? String ?? ""
        self.secret = json["secret"] as? String ?? ""

        let baseURLString = "https://farm\(farmID).staticflickr.com/"
        let resourceString = baseURLString.appending("\(serverID)/\(photoID)_\(secret)_z.jpg")

        guard
            let encoded = resourceString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encoded),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
            else { return nil }

        self.image = image
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(farmID, forKey: "farmID")
        aCoder.encode(serverID, forKey: "serverID")
        aCoder.encode(photoID, forKey: "photoID")
        aCoder.encode(secret, forKey: "secret")
        aCoder.encode(image, forKey: "image")
    }

    @discardableResult static func archive(_ workshops: [Workshop]) -> Bool {
        if NSKeyedArchiver.archiveRootObject(workshops, toFile: Workshop.ArchiveURL.path) {
            return true
        } else {
            return false
        }
    }

    static func removeAll() {
        if FileManager.default.fileExists(atPath: Workshop.ArchiveURL.path) {
            try? FileManager.default.removeItem(at: Workshop.ArchiveURL)
        }
    }

    typealias JSON = [String: Any]

    static func fetchAll(completion: @escaping ([Workshop]?) -> Void) {
        let apiKey = "3ac66971a7d99a38e522d76759fca2e1"
        let baseURLString = "https://api.flickr.com/services/rest/"
        let method = "flickr.galleries.getPhotos"
        let galleryID = "72157664540660544"
        let queryString = "?method=\(method)&api_key=\(apiKey)&gallery_id=\(galleryID)&format=json&nojsoncallback=1"
        let urlString = baseURLString.appending(queryString)
        let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encoded)!

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return completion(nil)
            }

            do {
                let any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let json = any as? JSON ?? [:]
                let dict = json["photos"] as? JSON ?? [:]
                let photos = dict["photo"] as? [JSON] ?? []

                let workshops = photos.flatMap(Workshop.init)
                completion(workshops)

            } catch {
                completion(nil)
            }
        }.resume()
    }
}
