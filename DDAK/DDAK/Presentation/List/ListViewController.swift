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
        let sortItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(sortItemTapped))
        let filterItem = UIBarButtonItem(image: UIImage(systemName: "camera.filters"), style: .plain, target: self, action: #selector(filterItemTapped))
        let writeItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(transitionToWriteViewController))
        navigationItem.leftBarButtonItems = [sortItem, filterItem]
        navigationItem.rightBarButtonItem = writeItem
    }
    
    @objc func sortItemTapped() {
        tasks = realm.objects(Diary.self).sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    @objc func filterItemTapped() {
//        tasks = realm.objects(Diary.self).filter("diaryTitle = 'Sea'")
        tasks = realm.objects(Diary.self).filter("diaryTitle CONTAINS[c] '날'")
    }
    
    @objc func transitionToWriteViewController() {
        let writeViewController = WriteViewController()
        navigationController?.pushViewController(writeViewController, animated: true)
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
        listView.tableView.rowHeight = 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.reuseIdentifier) as? DiaryCell else { return UITableViewCell() }
        cell.configure(with: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, completion in
            
            try! self.realm.write {
                self.tasks[indexPath.row].favorite.toggle()
                print("Realm Update Success! reloadRows 필요")
            }
            self.readDiary()
        }
        
        let systemImageName = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: systemImageName)
        favorite.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}
