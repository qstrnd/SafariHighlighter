//
//  NavigationCoordinator.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import UIKit

protocol NavigationCoordinatorProtocol: AnyObject {
    func perform(navigation: Navigation)
}

final class NavigationCoordinator: NSObject, NavigationCoordinatorProtocol {
    
    // MARK: - Internal
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
        
        navigationController.delegate = self
    }
    
    func perform(navigation: Navigation) {
        switch navigation {
        case .present(vc: let vc):
            present(vc: vc)
        case .push(vc: let vc):
            push(vc: vc)
        case .dismiss(vc: let vc):
            dismiss(vc: vc)
        case .pop(vc: let vc):
            pop(vc: vc)
        case .dismissLast:
            dismissLast()
        case .popLast:
            popLast()
        case .returnToRoot:
            returnToRoot()
        }
    }
    
    // MARK: - Private
    
    private let navigationController: UINavigationController
    
    // Keep track of all performed navigations
    private var navigations: [Navigation] = []
    
    private func present(vc: UIViewController) {
        navigations.append(.present(vc: vc))
        
        navigationController.present(vc, animated: true)
    }
    
    private func push(vc: UIViewController) {
        navigations.append(.push(vc: vc))
        
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func returnToRoot() {
        navigationController.dismiss(animated: true) {
            self.navigationController.popToRootViewController(animated: true)
        }
    }
    
    // MARK: Dismissing
    
    private func dismiss(vc: UIViewController) {
        guard let index = navigations.firstIndex(of: .present(vc: vc)) else { return }
        vc.dismiss(animated: true)
        navigations.removeSubrange(index...)
    }
    
    private func dismissLast() {
        guard let (vc, navigationIndex) = findLastPresentedController() else { return }
        vc.presentingViewController?.dismiss(animated: true)
        navigations.removeSubrange(navigationIndex...)
    }
    
    private func findLastPresentedController() -> (vc: UIViewController, navigationIndex: Int)? {
        for index in navigations.count ... 0 {
            let navigation = navigations[index]
            
            switch navigation {
            case .present(vc: let presentedVC):
                return (vc: presentedVC, navigationIndex: index)
            default:
                break
            }
        }
        
        return nil
    }
    
    // MARK: Popping
    
    private func pop(vc: UIViewController) {
        guard let index = navigations.firstIndex(of: .push(vc: vc)) else { return }
        navigationController.popViewController(animated: true)
        navigations.removeSubrange(index...)
    }
    
    private func popLast() {
        guard let (vc, navigationIndex) = findLastPushedController() else { return }
        vc.presentingViewController?.dismiss(animated: true)
        navigations.removeSubrange(navigationIndex...)
    }
    
    private func findLastPushedController() -> (vc: UIViewController, navigationIndex: Int)? {
        for index in navigations.count ... 0 {
            let navigation = navigations[index]
            
            switch navigation {
            case .push(vc: let pushedVC):
                return (vc: pushedVC, navigationIndex: index)
            default:
                break
            }
        }
        
        return nil
    }
    
}

// MARK: UINavigationControllerDelegate

extension NavigationCoordinator: UINavigationControllerDelegate {}
 
