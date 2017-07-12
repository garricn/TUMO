//
//  MyScheduleViewController
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/11/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

protocol MyScheduleViewControllerDelegate: class {
    func didTapLogOutButton(in viewController: UIViewController)
}

class MyScheduleViewController: UITableViewController {

    weak var delegate: MyScheduleViewControllerDelegate?

    private(set) var user: User

    private(set) var workshops: [Workshop]? {
        didSet {
            if let workshops = workshops, !workshops.isEmpty {
                Workshop.archive(workshops)
                state = .notEmpty(workshops)
            } else {
                state = .empty
            }
        }
    }

    private enum State {
        case loading
        case empty
        case notEmpty([Workshop])
    }

    private var state: State = .loading {
        didSet {
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }

    private var items: [Item] {
        switch self.state {
        case .loading:
            return [Item.init(text: "Loading...")]
        case .empty:
            return [Item.init(text: "No Workshops Found")]
        case .notEmpty(let workshops):
            return workshops.map(Item.init)
        }
    }

    private struct Item {
        let text: String
        let detail: String
        let image: UIImage?

        init(text: String, detail: String = "", image: UIImage? = nil) {
            self.text = text
            self.detail = detail
            self.image = image
        }

        init(workshop: Workshop) {
            self.text = workshop.name
            self.detail = workshop.shortDescription
            self.image = workshop.image
        }
    }

    init(user: User, workshops: [Workshop]?) {
        self.user = user
        self.workshops = workshops
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        if let workshops = workshops {
            state = .notEmpty(workshops)
        } else {
            state = .loading
            refresh()
        }
    }

    private func configureView() {
        title = "My Schedule"
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        let selector = #selector(didTapLogOut)
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: selector)
        navigationItem.rightBarButtonItem = logoutButton
    }

    @objc private func didTapLogOut(sender: UIBarButtonItem) {
        delegate?.didTapLogOutButton(in: self)
    }

    @objc private func didPullToRefresh(sender: UIRefreshControl) {
        refresh()
    }

    private func refresh() {
        Workshop.fetchAll(for: user) { workshops in
            DispatchQueue.main.async {
                self.workshops = workshops
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        let item = items[indexPath.row]
        let dequeuedCell = cell ?? UITableViewCell(style: .subtitle, reuseIdentifier: "myCell")
        dequeuedCell.textLabel?.text = item.text
        dequeuedCell.detailTextLabel?.text = item.detail
        dequeuedCell.imageView?.image = item.image
        return dequeuedCell
    }
}
