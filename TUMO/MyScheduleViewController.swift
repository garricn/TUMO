//
//  MyScheduleViewController
//  TUMO
//
//  Created by Garric G. Nahapetian on 7/11/17.
//  Copyright © 2017 TUMO. All rights reserved.
//

import UIKit

protocol MyScheduleViewControllerDelegate: class {
    func didTapLogOutButton(in viewController: MyScheduleViewController)
    func didPullToRefresh(in viewController: MyScheduleViewController)
}

class MyScheduleViewController: UITableViewController {

    weak var delegate: MyScheduleViewControllerDelegate?

    var user: User {
        didSet {
            if self.user.workshops.isEmpty {
                state = .empty
            } else {
                state = .notEmpty(user.workshops)
            }
        }
    }

    private var state: State = .loading {
        didSet {
            items = state.items
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }

    private var items: [Item] = []

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        if user.workshops.isEmpty {
            state = .loading
            refresh()
        } else {
            state = .notEmpty(user.workshops)
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
        delegate?.didPullToRefresh(in: self)
    }

    // MARK: - UITableViewDataSource

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

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        viewController.title = item.workshop?.name
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Nested Types

    private enum State {
        case loading
        case empty
        case notEmpty([Workshop])

        var items: [Item] {
            switch self {
            case .loading:
                return [Item(text: "Loading...")]
            case .empty:
                return [Item(text: "No Workshops Found")]
            case .notEmpty(let workshops):
                return workshops.map(Item.init)
            }
        }
    }

    private struct Item {
        let text: String
        let detail: String
        let image: UIImage?
        let workshop: Workshop?

        init(text: String, detail: String = "", image: UIImage? = nil, workshop: Workshop? = nil) {
            self.text = text
            self.detail = detail
            self.image = image
            self.workshop = workshop
        }

        init(workshop: Workshop) {
            self.init(text: workshop.name,
                      detail: workshop.shortDescription,
                      image: workshop.image,
                      workshop: workshop
            )
        }
    }
}
