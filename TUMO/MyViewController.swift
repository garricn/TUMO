//
//  MyViewController.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/11/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController, UISearchBarDelegate {

    let searchController = UISearchController(searchResultsController: nil)

    var names = ["Garen", "Garric", "Hayk", "Ani", "Lilit"]

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
//            names = names.filter { name in
//                return name.lowercased().contains(searchText.lowercased())
//            }

            var filterdNames: [String] = []

            for name in names {
                if name.lowercased().contains(searchText.lowercased()) {
                    filterdNames.append(name)
                }
            }

            names = filterdNames

            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar

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














