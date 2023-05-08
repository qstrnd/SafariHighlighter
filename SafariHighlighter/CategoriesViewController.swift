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

    init(
        categoryFetchController: CategoryFetchController,
        categoryService: CategoryService
    ) {
        self.categoryFetchController = categoryFetchController
        self.categoryService = categoryService

        super.init(nibName: nil, bundle: nil)

        categoryFetchController.delegate = self
        categoryFetchController.fetchResults()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)

        let addButton =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        navigationItem.rightBarButtonItem = addButton
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

    // MARK: - Private

    let categoryFetchController: CategoryFetchController
    let categoryService: CategoryService

    // MARK: Actions

    @objc
    private func addButtonTapped() {
        let newCategory = Category(name: "New category")

        categoryService.create(category: newCategory)
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