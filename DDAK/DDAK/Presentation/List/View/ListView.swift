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

        configureCalendar()
        
        backgroundColor = .systemBackground
        
        tableView.do {
            $0.backgroundColor = .clear
        }
    }
    
    override func configureLayout() {
        
        self.addSubview(tableView)
        self.addSubview(calendarView)
        
        calendarView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
            $0.top.equalTo(calendarView.snp.bottom).offset(20)
        }
    }
    
    private func configureCalendar() {
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.firstWeekday = 2
        calendarView.select(Date())
        calendarView.appearance.headerTitleFont = UIFont(name: "GamjaFlower-Regular", size: 17)
        calendarView.appearance.headerTitleColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1)
        calendarView.appearance.weekdayFont = UIFont(name: "GamjaFlower-Regular", size: 13)
        calendarView.appearance.weekdayTextColor = UIColor(red: 127/255, green: 132/255, blue: 135/255, alpha: 1)
        calendarView.appearance.titleFont = UIFont(name: "GamjaFlower-Regular", size: 15)
        calendarView.appearance.titleDefaultColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1)
        calendarView.appearance.titleTodayColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1)
        calendarView.appearance.todayColor = .clear
        calendarView.appearance.todaySelectionColor = .darkGray
        calendarView.appearance.titleSelectionColor = .white
        calendarView.appearance.selectionColor = .darkGray
    }
}
