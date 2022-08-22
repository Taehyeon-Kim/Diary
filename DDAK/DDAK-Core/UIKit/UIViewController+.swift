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
