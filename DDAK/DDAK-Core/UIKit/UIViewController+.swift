//
//  UIViewController+.swift
//  DDAK-Core
//
//  Created by taekki on 2022/08/23.
//

import UIKit

extension UIViewController {

    public func presentAlert(
        title: String,
        message: String? = nil,
        isCancelActionIncluded: Bool = false,
        preferredStyle style: UIAlertController.Style = .alert,
        handler: ((UIAlertAction) -> Void)? = nil
    )
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(confirmAction)
        if isCancelActionIncluded {
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case presentNavigation
        case presentFullNavigation
        case push
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
            
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
            
        case .presentFullNavigation:
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case .push:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        }
    }
}
