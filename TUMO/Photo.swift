//
//  Photo.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/13/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

struct Photo {
    let farmID: Int
    let serverID: String
    let photoID: String
    let secret: String
    let image: UIImage

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
}
