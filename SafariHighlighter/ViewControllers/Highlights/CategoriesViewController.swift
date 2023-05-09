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
        static let name = "Categories"
    }

    // MARK: - Internal

    init(
        categoryFetchController: CategoryFetchController,
        categoryService: CategoryService,
        highlightsCoordinator: IHighlightsControllerCoordinator
    ) {
        self.categoryFetchController = categoryFetchController
        self.categoryService = categoryService
        self.highlightsCoordinator = highlightsCoordinator

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

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryFetchController.numberOfCategories()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath)

        let category = categoryFetchController.object(at: indexPath)
        cell.textLabel?.text = category.creationDate.description

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

        let highlightsVC = highlightsCoordinator.buildHighlightsController(groupBy: .category(category))
        highlightsVC.title = category.name

        navigationController?.pushViewController(highlightsVC, animated: true)
    }

    // MARK: - Private

    private let categoryFetchController: CategoryFetchController
    private let categoryService: CategoryService
    private let highlightsCoordinator: IHighlightsControllerCoordinator

    // MARK: Actions

    @objc
    private func addButtonTapped() {
        let newCategory = Category(name: "New category")

        categoryService.create(category: newCategory)
    }

}

// MARK: - HighlightsGrouping
extension CategoriesViewController: HighlightsGrouping {
    var name: String {
        Constants.name
    }

    var navigationItems: [UIBarButtonItem] {
        let newItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        return [newItemButton]
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