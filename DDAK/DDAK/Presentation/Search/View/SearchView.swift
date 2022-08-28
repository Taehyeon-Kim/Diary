//
//  SearchView.swift
//  DDAK
//
//  Created by taekki on 2022/08/28.
//

import UIKit

import DDAK_Core
import SnapKit
import Then

final class SearchView: BaseView {
    
    lazy var searchBar = UISearchBar()
    lazy var tableView = UITableView(frame: .zero, style: .plain)
    
    override func configureAttributes() {
        
        self.backgroundColor = .systemBackground
        
        searchBar.do {
            $0.placeholder = "기록을 검색해보세요."
            $0.backgroundImage = UIImage()
            $0.searchTextField.font = .systemFont(ofSize: 14)
            $0.searchTextField.backgroundColor = .clear
        }
        
        tableView.do {
            $0.backgroundColor = .clear
            $0.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        }
    }
    
    override func configureLayout() {
        
        addSubviews(searchBar, tableView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
        }
    }
}
