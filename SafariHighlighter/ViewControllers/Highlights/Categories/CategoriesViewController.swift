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
        self.categoriesCellViewModelMapper = CategoriesCellViewModelMapper(appStorage: appStorage)

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

        tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryFetchController.numberOfCategories()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as! CategoriesTableViewCell

        let category = categoryFetchController.object(at: indexPath)
        let categoryViewModel = categoriesCellViewModelMapper.cellModel(from: category)
        cell.set(model: categoryViewModel)

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
            let category = categoryFetchController.object(at: indexPath)
            categoryService.delete(category: category)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryFetchController.object(at: indexPath)

        highlightsCoordinator.openHighlights(groupBy: .category(category))
    }

    // MARK: - Private

    private let appStorage: AppStorage
    private let categoryFetchController: CategoryFetchController
    private let categoryService: CategoryService
    private let highlightsCoordinator: HighlightsCoordinatorProtocol
    private let categoriesCellViewModelMapper: CategoriesCellViewModelMapper

}

// MARK: - HighlightsGrouping
extension CategoriesViewController: HighlightsGrouping {
    var name: String {
        Localized.GroupedHighlights.categories
    }

    var navigationItems: [UIBarButtonItem] {
        let sortButton = UIBarButtonItem(
            title: Localized.General.sort,
            menu: sortMenuForCurrentOptions()
        )

        return [sortButton]
    }
    
    private func sortMenuForCurrentOptions() -> UIMenu {
        let currentSortOrder = categoryFetchController.options.sortOrder
                
        let actions: [(title: String, sortOrder: CategoryFetchController.Options.SortOrder)] = [
            (Localized.Categories.sortByDefault, .creationDate),
            (Localized.Categories.sortByNumberOfHighlights, .numberOfHighlights)
        ]

        let menuChildren = actions.map { action in
            UIAction(
                title: action.title,
                image: currentSortOrder == action.sortOrder ? UIImage(systemName: "checkmark") : nil
            ) { [unowned self] _ in
                self.categoryFetchController.updateOptions(.init(sortOrder: action.sortOrder, showOnlyCategoriesWithHighlights: false)) {
                    self.tableView.reloadData()
                    self.delegate?.highlightGroupingRequestNavigationItemsUpdate(self)
                    
                    self.appStorage.categoriesSortOrderRaw = action.sortOrder.rawValue
                }
            }
        }

        return UIMenu(title: "", children: menuChildren)
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

}
