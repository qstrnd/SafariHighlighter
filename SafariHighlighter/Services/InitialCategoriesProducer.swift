//
//  InitialCategoriesProducer.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import Persistence


final class InitialCategoriesProducer {
    
    // MARK: - Internal
    
    init(
        categoryService: CategoryService,
        appStorage: AppStorage
    ) {
        self.categoryService = categoryService
        self.appStorage = appStorage
    }
    
    func generateInitialCategories(completion: @escaping () -> Void) {
        categoryService.create(categories: initialCategories) { [unowned self] result in
            guard case .success = result else { return }
            
            self.saveInitialCategoriesIds()
            
            completion()
        }
    }
    
    // MARK: - Private
    
    private let categoryService: CategoryService
    private let appStorage: AppStorage
    
    private var initialCategories = [
        Category(name: Localized.Colors.red),
        Category(name: Localized.Colors.orange),
        Category(name: Localized.Colors.yellow),
        Category(name: Localized.Colors.green),
        Category(name: Localized.Colors.blue),
        Category(name: Localized.Colors.purple)
    ]
    
    private func saveInitialCategoriesIds() {
        appStorage.initialCategoriesIdRed       = initialCategories[0].uniqueId
        appStorage.initialCategoriesIdOrange    = initialCategories[1].uniqueId
        appStorage.initialCategoriesIdYellow    = initialCategories[2].uniqueId
        appStorage.initialCategoriesIdGreen     = initialCategories[3].uniqueId
        appStorage.initialCategoriesIdBlue      = initialCategories[4].uniqueId
        appStorage.initialCategoriesIdPurple    = initialCategories[5].uniqueId
    }
}
