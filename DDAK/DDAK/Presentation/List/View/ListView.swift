//
//  ListView.swift
//  DDAK
//
//  Created by taekki on 2022/08/23.
//

import UIKit

import DDAK_Core
import SnapKit
import Then

final class ListView: BaseView {
    
    lazy var tableView = UITableView(frame: .zero, style: .plain)
    
    override func configureAttributes() {

        backgroundColor = .systemBackground
        
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
