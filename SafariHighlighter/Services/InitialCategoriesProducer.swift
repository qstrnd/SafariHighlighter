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
            
            completion()
        }
    }
    
    // MARK: - Private
    
    private let categoryService: CategoryService
    private let appStorage: AppStorage
    
    private var initialCategories = [
        Category(name: Localized.Colors.red, hexColor: "#FF3B30"),
        Category(name: Localized.Colors.orange, hexColor: "#FF9500"),
        Category(name: Localized.Colors.yellow, hexColor: "#FFCC00"),
        Category(name: Localized.Colors.green, hexColor: "#34C759"),
        Category(name: Localized.Colors.blue, hexColor: "#007AFF"),
        Category(name: Localized.Colors.purple, hexColor: "#AF52DE")
    ]
    
}
