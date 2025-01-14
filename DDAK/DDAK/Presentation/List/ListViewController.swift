//
//  ListViewController.swift
//  DDAK
//
//  Created by taekki on 2022/08/23.
//

import UIKit

import DDAK_Core
import DDAK_Network
import FSCalendar
import SnapKit
import Then
import RealmSwift

final class ListViewController: BaseViewController {
    
    private let listView = ListView()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYMMdd"
        return formatter
    }()
    
    var currentDate = Date().addingTimeInterval(-86400)
    
    private let repository: DiaryRepositoryType = DiaryRepository()
    var tasks: Results<Diary>! {
        didSet {
            listView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        self.view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tasks = self.repository.fetch(by: self.currentDate)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureAttributes() {
        super.configureAttributes()

        configureNavigationBar()
        configureTableView()
        configureCalendar()
    }
}

extension ListViewController {
    
    private func configureNavigationBar() {
        let label = UILabel()
        label.text = "DDAK"
        label.textColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1)
        label.font = UIFont(name: "GamjaFlower-Regular", size: 28)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)

        let sortButton = UIButton(type: .custom)
        sortButton.setImage(UIImage(named: "icn.sort"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortItemTapped), for: .touchUpInside)
        sortButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let sortItem = UIBarButtonItem(customView: sortButton)
        
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named: "icn.filter"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterItemTapped), for: .touchUpInside)
        filterButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let filterItem = UIBarButtonItem(customView: filterButton)
        
        let writeButton = UIButton(type: .custom)
        writeButton.setImage(UIImage(named: "icn.write"), for: .normal)
        writeButton.addTarget(self, action: #selector(transitionToWriteViewController), for: .touchUpInside)
        writeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let writeItem = UIBarButtonItem(customView: writeButton)

        navigationItem.rightBarButtonItems = [sortItem, filterItem, writeItem]
        navigationItem.rightBarButtonItems?.forEach {
            $0.customView?.tintColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1)
        }
        navigationItem.hidesBackButton = true
    }
    
    @objc func transitionToSettingViewController() {
        let writeViewController = SettingViewController()
        transition(writeViewController, transitionStyle: .presentFullNavigation)
    }
    
    @objc func sortItemTapped() {
        tasks = repository.sort(by: "diaryDate")
    }
    
    @objc func filterItemTapped() {
        tasks = repository.filter(by: "날")
    }
    
    @objc func transitionToWriteViewController() {
        let writeViewController = WriteViewController()
        transition(writeViewController, transitionStyle: .presentFullNavigation)
    }
}

extension ListViewController {
    
    private func readDiary() {
        tasks = repository.fetch(by: currentDate.addingTimeInterval(-86400))
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
        listView.tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        listView.tableView.rowHeight = UITableView.automaticDimension
        listView.tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.reuseIdentifier) as? DiaryCell else { return UITableViewCell() }
        let image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        cell.configure(with: tasks[indexPath.row], image: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completion in
            self.repository.update(item: self.tasks[indexPath.row]) { diary in
                diary.favorite.toggle()
            }
        }

        let systemImageName = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: systemImageName)
        favorite.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: "삭제") { action, view, completion in
            
            // - 프로퍼티로 관리
            // - 1. 데이터에 대한 정확성
            // - 2. 가독성
            let task = self.tasks[indexPath.row]
            
            // 삭제시 같은 데이터에 대해 동시에 접근하다보면 문제가 발생할 수 있음
            // - Record -> Image (문제 발생)
            // - Image -> Record (순서 변경 시 문제 해결) => 근본적인 해결책은 아님.
            self.repository.delete(item: task)
            self.tasks = self.repository.fetch(by: self.currentDate)
        }
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}

extension ListViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func configureCalendar() {
        listView.calendarView.delegate = self
        listView.calendarView.dataSource = self
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return repository.fetch(by: date).count
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [.darkGray]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [.darkGray]
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return formatter.string(from: date) == "220907" ? "오프라인행사" : nil
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        currentDate = date
        tasks = repository.fetch(by: currentDate)
    }
}
