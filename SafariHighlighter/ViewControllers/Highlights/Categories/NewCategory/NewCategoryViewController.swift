//
//  NewCategoryViewController.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import Persistence
import UIKit

final class NewCategoryViewController: UIViewController {
    
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let colorsHorizontalInset: CGFloat = 8
        static let verticalInset: CGFloat = 12
        static let colorButtonSize: CGSize = .init(square: 32)
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 18
    }
    
    // MARK: Internal
    
    init(
        categoryService: CategoryService,
        highlightsCoordinator: HighlightsCoordinatorProtocol
    ) {
        self.categoryService = categoryService
        self.highlightsCoordinator = highlightsCoordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = Localized.Categories.newCategory
        navigationItem.leftBarButtonItem = cancelButtonItem
        navigationItem.rightBarButtonItem = saveButtonItem
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(areaOutsideTextfieldTapped))
        view.addGestureRecognizer(tap)
        
        categoryColorPicker.delegate = self
        categoryColorPicker.numberOfCircles = 24
        
        updateSaveButton()
        setupLayout()
        
        setupTextField()
        setupColorPicker()
        setupHelpLabel()
        
    }
    
    // MARK: - Private
    
    private var selectedColor: UIColor? {
        didSet {
            colorPickerButton.backgroundColor = selectedColor
            
            updateSaveButton()
        }
    }
    
    private var name: String? {
        didSet {
            updateSaveButton()
        }
    }
    
    private let categoryService: CategoryService
    private let highlightsCoordinator: HighlightsCoordinatorProtocol
    
    private let textField = UITextField()
    private let colorPickerButton = UIButton()
    private let helpLabel = UILabel()
    private let categoryColorPicker = NewCategoryColorPickerView()
    
    private lazy var cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
    private lazy var saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    
    private func updateSaveButton() {
        saveButtonItem.isEnabled = !(name ?? "").isEmpty && selectedColor != nil
    }
    
    private func setupLayout() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(colorPickerButton)
        colorPickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(helpLabel)
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(categoryColorPicker)
        categoryColorPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorPickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            colorPickerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.verticalInset),
            colorPickerButton.widthAnchor.constraint(equalToConstant: Constants.colorButtonSize.width),
            colorPickerButton.heightAnchor.constraint(equalToConstant: Constants.colorButtonSize.height),
            
            textField.leadingAnchor.constraint(equalTo: colorPickerButton.trailingAnchor, constant: Constants.horizontalSpacing),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            textField.centerYAnchor.constraint(equalTo: colorPickerButton.centerYAnchor),
            
            helpLabel.topAnchor.constraint(equalTo: colorPickerButton.bottomAnchor, constant: Constants.verticalSpacing),
            helpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            helpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            
            categoryColorPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.colorsHorizontalInset),
            categoryColorPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.colorsHorizontalInset),
            categoryColorPicker.topAnchor.constraint(equalTo: helpLabel.bottomAnchor, constant: Constants.verticalSpacing),
            categoryColorPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.verticalInset),
        ])
    }
    
    private func setupTextField() {
        textField.borderStyle = .none
        textField.placeholder = Localized.Categories.newCategoryNameHint
        textField.returnKeyType = .next
        textField.delegate = self
    }
    
    private func setupHelpLabel() {
        helpLabel.text = Localized.Categories.newCategoryColorHint
        helpLabel.textColor = .tertiaryLabel
        helpLabel.font = .preferredFont(forTextStyle: .callout)
        helpLabel.numberOfLines = 0
    }
    
    private func setupColorPicker() {
        colorPickerButton.setImage(UIImage(systemName: "paintpalette.fill"), for: .normal)
        colorPickerButton.tintColor = .white
        colorPickerButton.backgroundColor = .gray
        colorPickerButton.layer.cornerRadius = Constants.colorButtonSize.width / 2
        colorPickerButton.addTarget(self, action: #selector(colorPickerButtonTapped), for: .touchUpInside)
    }

    // MARK: Actions

    @objc
    private func cancelButtonTapped() {
        highlightsCoordinator.dismiss()
    }
    
    @objc
    private func saveButtonTapped() {
        let category = Category(name: name ?? "", hexColor: selectedColor?.toHexString() ?? "")
        
        categoryService.create(category: category) { [weak self] _ in
            self?.highlightsCoordinator.dismiss()
        }
    }
            
    @objc
    private func colorPickerButtonTapped() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc
    private func areaOutsideTextfieldTapped() {
        textField.resignFirstResponder()
    }
}


// MARK: - UIColorPickerViewControllerDelegate

extension NewCategoryViewController: UIColorPickerViewControllerDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        textField.resignFirstResponder()
    }
}

// MARK: - NewCategoryColorPickerViewDelegate

extension NewCategoryViewController: NewCategoryColorPickerViewDelegate {
    
    func categoryColorPicker(_ colorPicker: NewCategoryColorPickerView, didSelectColor color: UIColor) {
        selectedColor = color
        textField.resignFirstResponder()
    }
    
}

// MARK: - UIColorPickerViewControllerDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        name = textField.text ?? ""
    }
    
}
