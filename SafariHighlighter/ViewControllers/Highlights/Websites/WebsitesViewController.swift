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
    }

    // MARK: - Internal
    
    weak var delegate: HighlightsGroupingDelegate?

    init(
        appStorage: AppStorage,
        websiteFetchController: WebsiteFetchController,
        websiteService: WebsiteService,
        highlightsCoordinator: HighlightsCoordinatorProtocol,
        imageCacheService: ImageCacheServiceProtocol
    ) {
        self.appStorage = appStorage
        self.websiteFetchController = websiteFetchController
        self.websiteService = websiteService
        self.highlightsCoordinator = highlightsCoordinator
        
        self.websiteCellConfigurator = WebsiteCellViewConfigurator(imageCacheService: imageCacheService)

        super.init(nibName: nil, bundle: nil)

        websiteFetchController.delegate = self
        websiteFetchController.fetchResults { [unowned self] in
            self.tableView.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(WebsiteTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)
        tableView.allowsMultipleSelectionDuringEditing = true
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websiteFetchController.numberOfWebsites()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as! WebsiteTableViewCell

        let website = websiteFetchController.object(at: indexPath)
        
        websiteCellConfigurator.configure(website: website, in: cell)
        
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInModalEditing {
            updateDeleteButton()
        } else {
            let website = websiteFetchController.object(at: indexPath)
            
            highlightsCoordinator.openHighlights(groupBy: .website(website))
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isInModalEditing { updateDeleteButton() }
    }

    // MARK: - Private
    
    private var isInModalEditing = false

    private let appStorage: AppStorage
    private let websiteFetchController: WebsiteFetchController
    private let websiteService: WebsiteService
    private let highlightsCoordinator: HighlightsCoordinatorProtocol
    private let websiteCellConfigurator: WebsiteCellViewConfigurator
    
    private lazy var addWebsiteButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    
    private lazy var batchDeleteButtonItem = UIBarButtonItem(title: Localized.General.delete, style: .done, target: self, action: #selector(batchDeleteButtonTapped))
    private lazy var enableBatchEditingButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableBatchEditingButtonTapped))
    private lazy var disableBatchEditingButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(disableBatchEditingButtonTapped))
    
    private func updateDeleteButton() {
        batchDeleteButtonItem.isEnabled = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
    }
    
    private func updateForCurrentMode() {
        setEditing(isInModalEditing, animated: true)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !isInModalEditing
        
        updateDeleteButton()
        delegate?.highlightGroupingRequestNavigationItemsUpdate(self)
    }

    // MARK: Actions

    @objc
    private func addButtonTapped() {
        let newWebsite = Website(name: "New Website", url: URL(string: "https://google.com")!)

        websiteService.create(website: newWebsite)
    }
    
    @objc
    private func batchDeleteButtonTapped() {
        ConfirmationDialog.show(
            from: self,
            title: Localized.Websites.deletionConfirmationTitle,
            message: Localized.Websites.deletionConfirmationSubtitle
        ) { [unowned self] in
            let websites = tableView.indexPathsForSelectedRows?.map {
                websiteFetchController.object(at: $0)
            } ?? []
            
            websiteService.delete(websites: websites) { [unowned self] _ in
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

// MARK: - HighlightsGrouping
extension WebsitesViewController: HighlightsGrouping {
    var name: String {
        Localized.GroupedHighlights.websites
    }
    
    var rightNavigationItems: [UIBarButtonItem] {
        if isInModalEditing {
            return [disableBatchEditingButtonItem]
        } else {
            return [enableBatchEditingButtonItem, addWebsiteButtonItem]
        }
    }
    
    var leftNavigationItems: [UIBarButtonItem] {
        if isInModalEditing {
            return [batchDeleteButtonItem]
        } else {
            let sortButton = UIBarButtonItem(
                title: Localized.General.sort,
                menu: sortMenuForCurrentOptions()
            )

            return [sortButton]
        }
    }
    
    var showSegmentedControl: Bool {
        !isInModalEditing
    }
    
    private func sortMenuForCurrentOptions() -> UIMenu {
        let sortFieldOptions = sortFieldOptionMenu()
        let sortDirection = sortDirectionMenu()

        return UIMenu(title: Localized.Websites.sortWebsites, children: [sortFieldOptions, sortDirection])
    }
    
    private func sortFieldOptionMenu() -> UIMenu {
        let currentSortOrder = websiteFetchController.options.sortOrder
        let sortOrderAsceding = websiteFetchController.options.sortOrderAsceding
        
        let actions: [(title: String, sortOrder: WebsiteFetchController.Options.SortField, image: UIImage?)] = [
            (
                Localized.Sort.sortByCreationDate,
                .creationDate,
                UIImage(systemName: "calendar")
            ),
            (
                Localized.Sort.sortByNumberOfHighlights,
                .numberOfHighlights,
                UIImage(systemName: "number.square")
            ),
            (
                Localized.Sort.sortByName,
                .name,
                UIImage(systemName: "a.square")
            )
        ]

        let menuChildren = actions.map { action in
            UIAction(
                title: action.title,
                image: action.image,
                state: currentSortOrder == action.sortOrder ? .on : .off
            ) { [unowned self] _ in
                self.websiteFetchController.updateOptions(.init(sortOrder: action.sortOrder, sortOrderAsceding: sortOrderAsceding)) {
                    self.tableView.reloadData()
                    self.delegate?.highlightGroupingRequestNavigationItemsUpdate(self)
                    
                    self.appStorage.websitesSortOrderRaw = action.sortOrder.rawValue
                }
            }
        }
        
        return UIMenu(title: "", options: .displayInline, children: menuChildren)
    }
    
    private func sortDirectionMenu() -> UIMenu {
        let currentSortOrder = websiteFetchController.options.sortOrder
        let sortOrderAsceding = websiteFetchController.options.sortOrderAsceding
        
        let actions: [(title: String, sortOrderAscending: Bool, image: UIImage?)] = [
            (
                Localized.Sort.sortAscending,
                true,
                UIImage(named: "ascending-16")
            ),
            (
                Localized.Sort.sortDescending,
                false,
                UIImage(named: "descending-16")
            )
        ]
        
        let menuChildren = actions.map { action in
            UIAction(
                title: action.title,
                image: action.image,
                state: sortOrderAsceding == action.sortOrderAscending ? .on : .off
            ) { [unowned self] _ in
                self.websiteFetchController.updateOptions(.init(sortOrder: currentSortOrder, sortOrderAsceding: action.sortOrderAscending)) {
                    self.tableView.reloadData()
                    self.delegate?.highlightGroupingRequestNavigationItemsUpdate(self)
                    
                    self.appStorage.websitesSortOrderAscending = action.sortOrderAscending
                }
            }
        }
        
        return UIMenu(title: "", options: .displayInline, children: menuChildren)
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
    
    func websiteFetchControllerDidRequestDataReload(_ controller: Persistence.WebsiteFetchController) {
        tableView.reloadData()
    }

}

