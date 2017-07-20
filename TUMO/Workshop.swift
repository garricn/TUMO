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
    let image: UIImage
    let shortDescription: String
    let longDescription: String
    let realStartDate: Date

    init(name: String,
         startDate: String,
         endDate: String,
         leader: String,
         image: UIImage,
         shortDescription: String,
         longDescription: String,
         realStartDate: Date) {

        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.leader = leader
        self.image = image
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.realStartDate = realStartDate
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: .name) as? String,
            let startDate = aDecoder.decodeObject(forKey: .startDate) as? String,
            let endDate = aDecoder.decodeObject(forKey: .endDate) as? String,
            let leader = aDecoder.decodeObject(forKey: .leader) as? String,
            let image = aDecoder.decodeObject(forKey: .image) as? UIImage,
            let short = aDecoder.decodeObject(forKey: .short) as? String,
            let long = aDecoder.decodeObject(forKey: .long) as? String,
            let realStartDate = aDecoder.decodeObject(forKey: "realStartDate") as? Date else {
                return nil
        }

        self.init(name: name,
                  startDate: startDate,
                  endDate: endDate,
                  leader: leader,
                  image: image,
                  shortDescription: short,
                  longDescription: long,
                  realStartDate: realStartDate)
    }

    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary[.name] as? String,
            let startDateString = dictionary[.startDate] as? String,
            let endDate = dictionary[.endDate] as? String,
            let leader = dictionary[.leader] as? String,
            let imageName = dictionary[.imageName] as? String,
            let image = UIImage.init(named: imageName),
            let short = dictionary[.short] as? String,
            let realStartDate = DateFormatter.date(from: startDateString, with: .yyyyMMddTHHmmssZ),
            let long = dictionary[.long] as? String else {
                return nil
        }

        self.init(name: name,
                  startDate: startDateString,
                  endDate: endDate,
                  leader: leader,
                  image: image,
                  shortDescription: short,
                  longDescription: long,
                  realStartDate: realStartDate
        )
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: .name)
        aCoder.encode(startDate, forKey: .startDate)
        aCoder.encode(endDate, forKey: .endDate)
        aCoder.encode(leader, forKey: .leader)
        aCoder.encode(image, forKey: .image)
        aCoder.encode(shortDescription, forKey: .short)
        aCoder.encode(longDescription, forKey: .long)
        aCoder.encode(realStartDate, forKey: "realStartDate")
    }
}

// MARK: - JSON & Coding Keys

private extension String {
    static let name = "name"
    static let startDate = "startDate"
    static let endDate = "endDate"
    static let leader = "leader"
    static let image = "image"
    static let imageName = "imageName"
    static let short = "short"
    static let long = "long"
}
