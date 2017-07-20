//
//  MyTableViewCell.swift
//  TUMO
//
//  Created by admin on 7/20/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    let myImageView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(myImageView)
        
        myImageView.contentMode = .scaleAspectFill
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        
        myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        myImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        myImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        myImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
