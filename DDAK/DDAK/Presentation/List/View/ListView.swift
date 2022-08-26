//
//  ListView.swift
//  DDAK
//
//  Created by taekki on 2022/08/23.
//

import UIKit

import DDAK_Core
import FSCalendar
import SnapKit
import Then

final class ListView: BaseView {
    
    lazy var tableView = UITableView(frame: .zero, style: .plain)
    lazy var calendarView = FSCalendar()
    
    override func configureAttributes() {

        backgroundColor = .systemBackground
        
        tableView.do {
            $0.backgroundColor = .clear
        }
    }
    
    override func configureLayout() {
        
        self.addSubview(tableView)
        self.addSubview(calendarView)
        
        tableView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
            $0.topMargin.equalTo(300)
        }
        
        calendarView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }
    }
}
