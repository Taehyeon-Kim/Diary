//
//  SettingView.swift
//  DDAK
//
//  Created by taekki on 2022/08/25.
//

import UIKit

import DDAK_Core
import SnapKit
import Then

final class SettingView: BaseView {
    
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func configureAttributes() {

        backgroundColor = .systemGray6
        
        tableView.do {
            $0.backgroundColor = .clear
        }
    }
    
    override func configureLayout() {
        
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
