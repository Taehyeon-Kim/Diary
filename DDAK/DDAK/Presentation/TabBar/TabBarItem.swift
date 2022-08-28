//
//  TabBarItem.swift
//  DDAK
//
//  Created by taekki on 2022/08/28.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case home, search, setting
}

extension TabBarItem {
    
    private var title: String {
        switch self {
        case .home:
            return "홈"
        case .search:
            return "검색"
        case .setting:
            return "설정"
        }
    }
    
    private var defaultImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "icn.calendar")?.withRenderingMode(.alwaysOriginal)
        case .search:
            return UIImage(named: "icn.search")?.withRenderingMode(.alwaysOriginal)
        case .setting:
            return UIImage(named: "icn.setting")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    private var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "icn.calendar.fill")?.withRenderingMode(.alwaysOriginal)
        case .search:
            return UIImage(named: "icn.search.fill")?.withRenderingMode(.alwaysOriginal)
        case .setting:
            return UIImage(named: "icn.setting.fill")?.withRenderingMode(.alwaysOriginal)
        }
    }
}

extension TabBarItem {
    
    func toTabBarItem() -> UITabBarItem {
        return UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
    }
}
