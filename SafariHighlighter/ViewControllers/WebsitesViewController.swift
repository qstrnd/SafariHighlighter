//
//  WebsitesViewController.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 08.05.2023.
//

import UIKit
import Persistence

final class WebsitesViewController: UITableViewController {

    // MARK: - Nested

    private enum Constants {
        static let cellReuseId = "websiteCell"
        static let name = "Websites"
    }

    // MARK: - Internal

    init(
        websiteFetchController: WebsiteFetchController,
        websiteService: WebsiteService
    ) {
        self.websiteFetchController = websiteFetchController
        self.websiteService = websiteService

        super.init(nibName: nil, bundle: nil)

        websiteFetchController.delegate = self
        websiteFetchController.fetchResults()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websiteFetchController.numberOfWebsites()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath)

        let website = websiteFetchController.object(at: indexPath)
        cell.textLabel?.text = website.creationDate.description

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let website = websiteFetchController.object(at: indexPath)
            websiteService.delete(website: website)
        default:
            break
        }
    }

    // MARK: - Private

    let websiteFetchController: WebsiteFetchController
    let websiteService: WebsiteService

    // MARK: Actions

    @objc
    private func addButtonTapped() {
        let newWebsite = Website(name: "New Website", url: URL(string: "https://qstrnd.com")!)

        websiteService.create(website: newWebsite)
    }

}

// MARK: - HighlightsGrouping
extension WebsitesViewController: HighlightsGrouping {
    var name: String {
        Constants.name
    }

    var navigationItems: [UIBarButtonItem] {
        let newItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        return [newItemButton]
    }
}

// MARK: - WebsiteFetchControllerDelegate
extension WebsitesViewController: WebsiteFetchControllerDelegate {
    func websiteFetchController(_ controller: Persistence.WebsiteFetchController, didUpdateWebsitesAt indexPath: [IndexPath]) {
        tableView.reloadRows(at: indexPath, with: .automatic)
    }

    func websiteFetchController(_ controller: Persistence.WebsiteFetchController, didAddWebsites indexPath: [IndexPath]) {
        tableView.insertRows(at: indexPath, with: .automatic)
    }

    func websiteFetchController(_ controller: Persistence.WebsiteFetchController, didDeleteWebsites indexPath: [IndexPath]) {
        tableView.deleteRows(at: indexPath, with: .automatic)
    }

    func websiteFetchControllerWillBeginUpdates(_ controller: Persistence.WebsiteFetchController) {
        tableView.beginUpdates()
    }

    func websiteFetchControllerDidFinishUpdates(_ controller: Persistence.WebsiteFetchController) {
        tableView.endUpdates()
    }

}

