//
//  ConfirmationDialog.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import UIKit

final class ConfirmationDialog {
    static func show(from viewController: UIViewController, title: String, message: String, yesHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: Localized.General.yes, style: .destructive) { _ in
            yesHandler()
        }
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: Localized.General.no, style: .cancel, handler: nil)
        alertController.addAction(noAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
