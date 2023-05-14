//
//  CategoriesViewController.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 01.05.2023.
//

import UIKit
import Persistence

final class CategoriesViewController: UITableViewController {

    // MARK: - Nested

    private enum Constants {
        static let cellReuseId = "categoryCell"
        static let tableViewHeight: CGFloat = 44
    }

    // MARK: - Internal
    
    weak var delegate: HighlightsGroupingDelegate?

    init(
        appStorage: AppStorage,
        categoryFetchController: CategoryFetchController,
        categoryService: CategoryService,
        highlightsCoordinator: HighlightsCoordinatorProtocol
    ) {
        self.categoryFetchController = categoryFetchController
        self.categoryService = categoryService
        self.highlightsCoordinator = highlightsCoordinator
        self.appStorage = appStorage
        self.categoriesCellViewModelMapper = CategoryCellViewModelMapper()

        super.init(nibName: nil, bundle: nil)

        categoryFetchController.delegate = self
        categoryFetchController.fetchResults { [unowned self] in
            self.tableView.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)
        tableView.rowHeight = Constants.tableViewHeight
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryFetchController.numberOfCategories()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as! CategoryTableViewCell

        let category = categoryFetchController.object(at: indexPath)
        let categoryViewModel = categoriesCellViewModelMapper.cellModel(from: category)
        cell.set(model: categoryViewModel)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryFetchController.object(at: indexPath)

        highlightsCoordinator.openHighlights(groupBy: .category(category))
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
            let highlight = categoryFetchController.object(at: indexPath)
            categoryService.delete(category: highlight)
        default:
            break
        }
    }

    // MARK: - Private

    private let appStorage: AppStorage
    private let categoryFetchController: CategoryFetchController
    private let categoryService: CategoryService
    private let highlightsCoordinator: HighlightsCoordinatorProtocol
    private let categoriesCellViewModelMapper: CategoryCellViewModelMapper

}

// MARK: - HighlightsGrouping
extension CategoriesViewController: HighlightsGrouping {
    var name: String {
        Localized.GroupedHighlights.categories
    }
    
    var rightNavigationItems: [UIBarButtonItem] {
        let newItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        return [newItemButton]
    }

    var leftNavigationItems: [UIBarButtonItem] {
        let sortButton = UIBarButtonItem(
            title: Localized.General.sort,
            menu: sortMenuForCurrentOptions()
        )

        return [sortButton]
    }
    
    private func sortMenuForCurrentOptions() -> UIMenu {
        let sortFieldOptions = sortFieldOptionMenu()
        let sortDirection = sortDirectionMenu()

        return UIMenu(title: "", children: [sortFieldOptions, sortDirection])
    }
    
    private func sortFieldOptionMenu() -> UIMenu {
        let currentSortOrder = categoryFetchController.options.sortOrder
        let sortOrderAsceding = categoryFetchController.options.sortOrderAsceding
        
        let actions: [(title: String, sortOrder: CategoryFetchController.Options.SortField, image: UIImage?)] = [
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
                self.categoryFetchController.updateOptions(.init(sortOrder: action.sortOrder, sortOrderAsceding: sortOrderAsceding)) {
                    self.tableView.reloadData()
                    self.delegate?.highlightGroupingRequestNavigationItemsUpdate(self)
                    
                    self.appStorage.categoriesSortOrderRaw = action.sortOrder.rawValue
                }
            }
        }
        
        return UIMenu(title: "", options: .displayInline, children: menuChildren)
    }
    
    private func sortDirectionMenu() -> UIMenu {
        let currentSortOrder = categoryFetchController.options.sortOrder
        let sortOrderAsceding = categoryFetchController.options.sortOrderAsceding
        
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
                self.categoryFetchController.updateOptions(.init(sortOrder: currentSortOrder, sortOrderAsceding: action.sortOrderAscending)) {
                    self.tableView.reloadData()
                    self.delegate?.highlightGroupingRequestNavigationItemsUpdate(self)
                    
                    self.appStorage.categoriesSortOrderAscending = action.sortOrderAscending
                }
            }
        }
        
        return UIMenu(title: Localized.Sort.sortOrder, options: .displayInline, children: menuChildren)
    }
    
    // MARK: Actions

    @objc
    private func addButtonTapped() {
        highlightsCoordinator.openNewCategory()
    }
}

// MARK: - CategoryFetchControllerDelegate
extension CategoriesViewController: CategoryFetchControllerDelegate {
    func categoryFetchController(_ controller: Persistence.CategoryFetchController, didUpdateCategoriesAt indexPath: [IndexPath]) {
        tableView.reloadRows(at: indexPath, with: .automatic)
    }

    func categoryFetchController(_ controller: Persistence.CategoryFetchController, didAddCategories indexPath: [IndexPath]) {
        tableView.insertRows(at: indexPath, with: .automatic)
    }

    func categoryFetchController(_ controller: Persistence.CategoryFetchController, didDeleteCategories indexPath: [IndexPath]) {
        tableView.deleteRows(at: indexPath, with: .automatic)
    }

    func categoryFetchControllerWillBeginUpdates(_ controller: Persistence.CategoryFetchController) {
        tableView.beginUpdates()
    }

    func categoryFetchControllerDidFinishUpdates(_ controller: Persistence.CategoryFetchController) {
        tableView.endUpdates()
    }
    
    func categoryFetchControllerDidRequestDataReload(_ controller: CategoryFetchController) {
        tableView.reloadData()
    }

}
