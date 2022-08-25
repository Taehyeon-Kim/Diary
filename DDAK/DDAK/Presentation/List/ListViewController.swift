//
//  ListViewController.swift
//  DDAK
//
//  Created by taekki on 2022/08/23.
//

import UIKit

import DDAK_Core
import DDAK_Network
import SnapKit
import Then
import RealmSwift

final class ListViewController: BaseViewController {
    
    private let listView = ListView()
    
    private let realm = try! Realm()
    var tasks: Results<Diary>! { didSet { listView.tableView.reloadData() } }
    
    override func loadView() {
        self.view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readDiary()
    }
    
    override func configureAttributes() {
        configureNavigationBar()
        configureTableView()
    }
}

extension ListViewController {
    
    private func configureNavigationBar() {
        let label = UILabel()
        label.textColor = .black
        label.text = "DDAK"
        label.font = UIFont(name: "GamjaFlower-Regular", size: 28)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
        let settingButton = UIButton(type: .custom)
        settingButton.tintColor = .black
        settingButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingButton.addTarget(self, action: #selector(transitionToSettingViewController), for: .touchUpInside)
        settingButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let settingItem = UIBarButtonItem(customView: settingButton)
        
        let sortButton = UIButton(type: .custom)
        sortButton.tintColor = .black
        sortButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortItemTapped), for: .touchUpInside)
        sortButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let sortItem = UIBarButtonItem(customView: sortButton)
        
        let filterButton = UIButton(type: .custom)
        filterButton.tintColor = .black
        filterButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterItemTapped), for: .touchUpInside)
        filterButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let filterItem = UIBarButtonItem(customView: filterButton)
        
        let writeButton = UIButton(type: .custom)
        writeButton.tintColor = .black
        writeButton.setImage(UIImage(systemName: "plus"), for: .normal)
        writeButton.addTarget(self, action: #selector(transitionToWriteViewController), for: .touchUpInside)
        writeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let writeItem = UIBarButtonItem(customView: writeButton)

        navigationItem.rightBarButtonItems = [settingItem, sortItem, filterItem, writeItem]
        navigationItem.hidesBackButton = true
    }
    
    @objc func transitionToSettingViewController() {
        let writeViewController = SettingViewController()
        transition(writeViewController, transitionStyle: .presentFullNavigation)
    }
    
    @objc func sortItemTapped() {
        tasks = realm.objects(Diary.self).sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    @objc func filterItemTapped() {
        tasks = realm.objects(Diary.self).filter("diaryTitle CONTAINS[c] '날'")
    }
    
    @objc func transitionToWriteViewController() {
        let writeViewController = WriteViewController()
        transition(writeViewController, transitionStyle: .presentFullNavigation)
    }
}

extension ListViewController {
    
    private func readDiary() {
        tasks = realm.objects(Diary.self).sorted(byKeyPath: "diaryDate", ascending: true)
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
            
            try! self.realm.write {
                self.tasks[indexPath.row].favorite.toggle()
            }
            self.readDiary()
        }
        
        let systemImageName = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: systemImageName)
        favorite.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}
