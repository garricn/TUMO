//
//  MyViewController.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/11/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController {

    var names = ["Garen", "Garric", "Hayk", "Ani", "Lilit"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")

        let myBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(didTapAddButton))

        navigationItem.rightBarButtonItem = myBarButtonItem

        names.sort()
    }

    func didTapAddButton(sender: UIBarButtonItem) {
        let newString = "Item \(names.count)"
        names.append(newString)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        viewController.title = names[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}














