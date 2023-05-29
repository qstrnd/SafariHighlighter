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
            self.updatePlaceholderVisibility()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(HighlightTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)
        tableView.allowsMultipleSelectionDuringEditing = true

        setupViews()
        updateBarButtonItems()
        updatePlaceholderVisibility()
        
        navigationItem.title = title
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        highlightFetchController.numberOfHighlights()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as! HighlightTableViewCell

        let highlight = highlightFetchController.fullHighlight(at: indexPath)
        let model = cellMapper.cellModel(from: highlight)
        cell.set(model: model)
        
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
            let highlight = highlightFetchController.highlight(at: indexPath)
            highlightService.delete(highlight: highlight)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableView.isEditing ? indexPath : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateDeleteButton()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateDeleteButton()
    }

    // MARK: - Private

    private let highlightFetchController: HighlightFetchController
    private let highlightService: HighlightService
    private let relationshipService: RelationshipService
    private let groupByTrait: HighlightsGroupBy
    
    private let cellMapper = HighlightCellViewModelMapper()
    
    private var isInModalEditing = false
    
    private lazy var addHighlightButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    private lazy var batchDeleteButtonItem = UIBarButtonItem(title: Localized.General.delete, style: .done, target: self, action: #selector(batchDeleteButtonTapped))
    private lazy var enableBatchEditingButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableBatchEditingButtonTapped))
    private lazy var disableBatchEditingButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(disableBatchEditingButtonTapped))
    
    private lazy var placeholderViewController = PlaceholderViewController(text: Localized.Highlights.noHighlights)
    
    private func setupViews() {
        
        placeholderViewController.willMove(toParent: self)
        addChild(placeholderViewController)
        view.addSubview(placeholderViewController.view)
        placeholderViewController.didMove(toParent: self)
        
        let placeholderView = placeholderViewController.view!
        tableView.backgroundView = placeholderView
        
    }
    
    private func updatePlaceholderVisibility() {
        placeholderViewController.view.isHidden = highlightFetchController.numberOfHighlights() != 0 || isInModalEditing
    }
    
    private func updateForCurrentMode() {
        setEditing(isInModalEditing, animated: true)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !isInModalEditing
        
        updateDeleteButton()
        updateBarButtonItems()
    }
    
    private func updateBarButtonItems() {
        navigationItem.hidesBackButton = tableView.isEditing

        if tableView.isEditing {
            navigationItem.rightBarButtonItems = [disableBatchEditingButtonItem]
            navigationItem.leftBarButtonItem = batchDeleteButtonItem
        } else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItems = [enableBatchEditingButtonItem, addHighlightButtonItem]
        }
    }
    
    private func updateDeleteButton() {
        batchDeleteButtonItem.isEnabled = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
    }

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
    
    @objc
    private func batchDeleteButtonTapped() {
        ConfirmationDialog.show(
            from: self,
            title: Localized.Highlights.deletionConfirmationTitle,
            message: Localized.Highlights.deletionConfirmationSubtitle
        ) { [unowned self] in
            let highlights = tableView.indexPathsForSelectedRows?.map {
                highlightFetchController.highlight(at: $0)
            } ?? []
            
            highlightService.delete(highlights: highlights) { [unowned self] _ in
                isInModalEditing = false
                updateForCurrentMode()
            }
        }
    }
    
    @objc
    private func enableBatchEditingButtonTapped() {
        isInModalEditing = true
        
        updateForCurrentMode()
    }

    @objc
    private func disableBatchEditingButtonTapped() {
        isInModalEditing = false
        
        updateForCurrentMode()
    }
    
}

// MARK: - HighlightFetchControllerDelegate
extension HighlightsViewController: HighlightFetchControllerDelegate {
    func highlightFetchController(_ controller: Persistence.HighlightFetchController, didUpdateHighlightsAt indexPath: [IndexPath]) {
        tableView.reloadRows(at: indexPath, with: .automatic)
        updatePlaceholderVisibility()
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
        updatePlaceholderVisibility()
    }

}
