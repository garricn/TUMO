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
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }

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
        title = NSLocalizedString("My Schedule", comment: "")
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        let selector = #selector(didTapLogOut)
        let logoutButton = UIBarButtonItem(title: NSLocalizedString("Log Out", comment: ""), style: .plain, target: self, action: selector)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return state.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.sections[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        let item = state.sections[indexPath.section].items[indexPath.row]
        let dequeuedCell = cell ?? UITableViewCell(style: .subtitle, reuseIdentifier: "myCell")
        dequeuedCell.textLabel?.text = item.text
        dequeuedCell.detailTextLabel?.text = item.detail
        dequeuedCell.imageView?.image = item.image
        return dequeuedCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return state.sections[section].title
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let workshop = state.sections[indexPath.section].items[indexPath.row].workshop else {
            return
        }
        
        let viewController = WorkshopDetailViewController(workshop: workshop)
        viewController.view.backgroundColor = .white
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("Back", comment: "")
        navigationItem.backBarButtonItem = backItem
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
                return [Item(text: NSLocalizedString("Loading...", comment: ""))]
            case .empty:
                return [Item(text: NSLocalizedString("No Workshops Found", comment: ""))]
            case .notEmpty(let workshops):
                return workshops.map(Item.init)
            }
        }

        var sections: [Section] {
            switch self {
            case .empty:
                return [Section(title: "Empty", items: [Item(text: "No Workshops Found")])]
            case .loading:
                return [Section(title: nil, items: [Item(text: "Loading...")])]
            case .notEmpty(let workshops):
                return Section.sections(from: workshops)
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

    private struct Section {
        let title: String?
        let items: [Item]

        static func sections(from workshops: [Workshop]) -> [Section] {
            let allMonths: [String] = workshops.map { workshop in
                    return DateFormatter.string(from: workshop.realStartDate, with: .MMMM)
            }

            let set = Set(allMonths)

            let sections: [Section] = set.map { monthString in
                let workshopsForSection = workshops.filter { workshop in
                    let date = workshop.realStartDate
                    let month = DateFormatter.string(from: date, with: .MMMM)
                    return monthString == month
                }
                let itemsForSection = workshopsForSection.map(Item.init)
                return Section.init(title: NSLocalizedString(monthString, comment:""), items: itemsForSection)
            }

            return sections
        }
    }
}
