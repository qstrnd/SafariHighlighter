//
//  HighlightsViewController.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 08.05.2023.
//

import UIKit
import Persistence

final class HighlightsViewController: UITableViewController {

    // MARK: - Nested

    private enum Constants {
        static let cellReuseId = "highlightCell"
        static let name = "Highlights"
    }

    // MARK: - Internal

    init(
        highlightFetchController: HighlightFetchController,
        highlightService: HighlightService,
        relationshipService: RelationshipService,
        groupByTrait: HighlightsGroupBy
    ) {
        self.highlightFetchController = highlightFetchController
        self.highlightService = highlightService
        self.relationshipService = relationshipService
        self.groupByTrait = groupByTrait

        super.init(nibName: nil, bundle: nil)

        highlightFetchController.delegate = self
        highlightFetchController.fetchResults { [unowned self] in
            self.tableView.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        navigationItem.title = title
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        highlightFetchController.numberOfHighlights()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath)

        let highlight = highlightFetchController.object(at: indexPath)
        cell.textLabel?.text = highlight.creationDate.description

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
            let highlight = highlightFetchController.object(at: indexPath)
            highlightService.delete(highlight: highlight)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    // MARK: - Private

    let highlightFetchController: HighlightFetchController
    let highlightService: HighlightService
    let relationshipService: RelationshipService
    let groupByTrait: HighlightsGroupBy

    // MARK: Actions

    @objc
    private func addButtonTapped() {
        let newHighlight = Highlight(text: "BlaBla", location: ".class[0]#id")
        highlightService.create(highlight: newHighlight)

        switch groupByTrait {
        case .category(let category):
            relationshipService.associate(highlight: newHighlight, with: category)
        case .website(let website):
            relationshipService.associate(highlight: newHighlight, with: website)
        }
    }

}

// MARK: - HighlightFetchControllerDelegate
extension HighlightsViewController: HighlightFetchControllerDelegate {
    func highlightFetchController(_ controller: Persistence.HighlightFetchController, didUpdateHighlightsAt indexPath: [IndexPath]) {
        tableView.reloadRows(at: indexPath, with: .automatic)
    }

    func highlightFetchController(_ controller: Persistence.HighlightFetchController, didAddHighlights indexPath: [IndexPath]) {
        tableView.insertRows(at: indexPath, with: .automatic)
    }

    func highlightFetchController(_ controller: Persistence.HighlightFetchController, didDeleteHighlights indexPath: [IndexPath]) {
        tableView.deleteRows(at: indexPath, with: .automatic)
    }

    func highlightFetchControllerWillBeginUpdates(_ controller: Persistence.HighlightFetchController) {
        tableView.beginUpdates()
    }

    func highlightFetchControllerDidFinishUpdates(_ controller: Persistence.HighlightFetchController) {
        tableView.endUpdates()
    }

}
