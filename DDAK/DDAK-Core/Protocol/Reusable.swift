//
//  Reusable.swift
//  DDAK-Core
//
//  Created by taekki on 2022/08/22.
//

import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension UIViewController: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
