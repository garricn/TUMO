//
//  Workshop.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/13/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class Workshop: NSObject, NSCoding {
    let name: String
    let startDate: String
    let endDate: String
    let leader: String
    let focusArea: FocusArea
    let skill: Skill
    let image: UIImage
    let shortDescription: String
    let longDescription: String

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("workshops")

    static var unarchived: [Workshop]? {
        let file = Workshop.ArchiveURL.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: file) as? [Workshop]
    }

    init(name: String,
         startDate: String,
         endDate: String,
         leader: String,
         focusArea: FocusArea,
         skill: Skill, image: UIImage, shortDescription: String, longDescription: String) {

        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.leader = leader
        self.focusArea = focusArea
        self.skill = skill
        self.image = image
        self.shortDescription = shortDescription
        self.longDescription = longDescription
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let focusAreaRawValue = aDecoder.decodeInteger(forKey: .focusArea)
        let skillRawValue = aDecoder.decodeInteger(forKey: .skill)

        guard let name = aDecoder.decodeObject(forKey: .name) as? String,
            let startDate = aDecoder.decodeObject(forKey: .startDate) as? String,
            let endDate = aDecoder.decodeObject(forKey: .endDate) as? String,
            let leader = aDecoder.decodeObject(forKey: .leader) as? String,
            let focusArea = FocusArea(rawValue: focusAreaRawValue),
            let skill = Skill(rawValue: skillRawValue),
            let image = aDecoder.decodeObject(forKey: .image) as? UIImage,
            let short = aDecoder.decodeObject(forKey: .short) as? String,
            let long = aDecoder.decodeObject(forKey: .long) as? String else {
                return nil
        }

        self.init(name: name,
                  startDate: startDate,
                  endDate: endDate,
                  leader: leader,
                  focusArea: focusArea,
                  skill: skill,
                  image: image,
                  shortDescription: short,
                  longDescription: long)
    }

    convenience init?(dictionary: Workshop.JSON) {
        guard let name = dictionary[.name] as? String,
            let startDate = dictionary[.startDate] as? String,
            let endDate = dictionary[.endDate] as? String,
            let leader = dictionary[.leader] as? String,
            let imageName = dictionary[.imageName] as? String,
            let image = UIImage.init(named: imageName),
            let short = dictionary[.short] as? String,
            let long = dictionary[.long] as? String,
            let focusAreaRawValue = dictionary[.focusArea] as? Int,
            let skillRawValue = dictionary[.skill] as? Int,
            let focusArea = FocusArea(rawValue: focusAreaRawValue),
            let skill = Skill(rawValue: skillRawValue) else {
                return nil
        }

        self.init(name: name,
                  startDate: startDate,
                  endDate: endDate,
                  leader: leader,
                  focusArea: focusArea,
                  skill: skill,
                  image: image,
                  shortDescription: short,
                  longDescription: long)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: .name)
        aCoder.encode(startDate, forKey: .startDate)
        aCoder.encode(endDate, forKey: .endDate)
        aCoder.encode(leader, forKey: .leader)
        aCoder.encode(focusArea.rawValue, forKey: .focusArea)
        aCoder.encode(skill.rawValue, forKey: .skill)
        aCoder.encode(image, forKey: .image)
        aCoder.encode(shortDescription, forKey: .short)
        aCoder.encode(longDescription, forKey: .long)
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

    static func fetchAll(for user: User, completion: @escaping ([Workshop]?) -> Void) {

        // NOTE: We're using the Flikr API as an example of how to make a network request
        // TODO: Replace the following with TUMO API using User ID when the API becomes available

        let apiKey = "3ac66971a7d99a38e522d76759fca2e1"
        let method = "flickr.galleries.getPhotos"
        let galleryID = "72157664540660544"
        let queryString = "?method=\(method)&api_key=\(apiKey)&gallery_id=\(galleryID)&format=json&nojsoncallback=1"
        let baseURLString = "https://api.flickr.com/services/rest/"
        let urlString = baseURLString.appending(queryString)

        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encoded) else {
                return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            /*

             NOTE: 
             
             This is an example of parsing JSON from a network response
             This is using the Flikr API
             
             TODO: 
             
             Replace JSON parsing dictionary keys ("photos", "photo") with TUMO API real keys

             guard let data = data else {
             return completion(nil)
             }

             let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
             let json = object as? JSON ?? [:]
             let dict = json["photos"] as? JSON ?? [:] // Replace "photos" key as appropirate
             let photos = dict["photo"] as? [JSON] ?? [] // // Replace "photo" key as appropirate
             let workshops = photos.flatMap(Workshop.init)
             completion(workshops)
            
            */

            // NOTE: - We're using mockWorkshop.json file to populate our Workshop data
            // TODO: - Delete this once real TUMO API is in place

            guard let path = Bundle.main.path(forResource: "mockWorkshops", ofType: "json"),
                let dataString = try? String(contentsOfFile: path),
                let data = dataString.data(using: .utf8) else {
                    return completion(nil)
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let dictionaries = json as? [JSON]
                let workshops = dictionaries?.flatMap(Workshop.init)
                completion(workshops)
            } catch {
                print(error)
            }
        }.resume()
    }
}

// MARK: - JSON & Coding Keys

private extension String {
    static let name = "name"
    static let startDate = "startDate"
    static let endDate = "endDate"
    static let leader = "leader"
    static let focusArea = "focusArea"
    static let skill = "skill"
    static let image = "image"
    static let imageName = "imageName"
    static let short = "short"
    static let long = "long"
}
