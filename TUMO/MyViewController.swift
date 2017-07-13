//
//  MyViewController.swift
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/11/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController {

    var items: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "myCell")

        refresh()
    }

    func didPullToRefresh(sender: UIRefreshControl) {
        refresh()
    }

    typealias JSON = [String: Any]

    func refresh() {
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

                if let response = response {
                    print(response)
                }

                if let error = error {
                    print(error)
                }
                return
            }

            do {
                let any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let json = any as? JSON ?? [:]
                let dict = json["photos"] as? JSON ?? [:]
                let photos = dict["photo"] as? [JSON] ?? []

                self.items = photos.flatMap(Photo.init)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }

            } catch {
                print(error)
            }
        }.resume()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let myCell = cell as! MyTableViewCell
        myCell.myImageView.image = items[indexPath.row].image
        return myCell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
//        viewController.title = items[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
