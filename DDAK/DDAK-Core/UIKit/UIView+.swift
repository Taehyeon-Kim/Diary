//
//  UIView+.swift
//  DDAK-Core
//
//  Created by taekki on 2022/08/22.
//

import UIKit

extension UIView {
    
    public func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
