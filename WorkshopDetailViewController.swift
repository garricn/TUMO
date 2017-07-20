//
//  WorkshopDetailViewController.swift
//  TUMO
//
//  Created by admin on 7/18/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

final class WorkshopDetailViewController: UITableViewController {

    let workshop: Workshop
    
    private var sections: [Section] {
        return Section.sections(from: workshop)
    }

    init(workshop: Workshop) {
        self.workshop = workshop
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Workshop Details"
        tableView.estimatedRowHeight = 50
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "imageCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
            let imageCell = cell as! MyTableViewCell
            imageCell.myImageView.image = workshop.image
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "simpleCell")
            let item = sections[indexPath.section].item
            cell.textLabel?.text = item
            cell.textLabel?.numberOfLines = 0
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let image = UIImage(named: "Programming")!
            let ratio = image.size.height / image.size.width
            return UIScreen.main.bounds.width * ratio + 20
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return sections[section].title
        }
    }
    
    private struct Section {
        let title: String
        let item: String
        
        static func sections(from workshop: Workshop) -> [Section] {
            return[
                Section(title: "Image", item: "Image"),
                Section(title: "Name", item: workshop.name),
                Section(title: "Leader", item: workshop.leader),
                Section(title: "Date", item: workshop.startDate + workshop.endDate),
                Section(title: "Description", item: workshop.longDescription)
            ]
        }
    }
}
