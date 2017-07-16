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

    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary[.name] as? String,
            let startDate = dictionary[.startDate] as? String,
            let endDate = dictionary[.endDate] as? String,
            let leader = dictionary[.leader] as? String,
            let imageName = dictionary[.imageName] as? String,
            let image = UIImage.init(named: imageName),
            let short = dictionary[.short] as? String,
            let long = dictionary[.long] as? String,
            let focusAreaString = dictionary[.focusArea] as? String,
            let skillString = dictionary[.skill] as? String,
            let focusAreaInt = Int(focusAreaString),
            let skillInt = Int(skillString),
            let focusArea = FocusArea(rawValue: focusAreaInt),
            let skill = Skill(rawValue: skillInt) else {
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
