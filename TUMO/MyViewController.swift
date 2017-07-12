//
//  MyViewController.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/11/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController, UISearchBarDelegate {

    let names = ["Garen", "Garric", "Hayk", "Ani", "Lilit"]

    var items: [String] = []

    let searchController = UISearchController.init(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")

        let myBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(didTapAddButton))

        navigationItem.rightBarButtonItem = myBarButtonItem

        items = names.sorted()


        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }

    func didTapAddButton(sender: UIBarButtonItem) {
        let newString = "Item \(items.count)"
        items.append(newString)
        let indexPath = IndexPath(row: items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        cell.textLabel?.text = items[indexPath.row].uppercased()

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        viewController.title = items[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = names.filter { $0.contains(searchBar.text!) }
        tableView.reloadData()
        searchController.dismiss(animated: true, completion: nil)
    }
}














