//
//  SearchViewController.swift
//  DDAK
//
//  Created by taekki on 2022/08/28.
//

import UIKit

import DDAK_Core
import DDAK_Network
import SnapKit
import Then
import RealmSwift

final class SearchViewController: BaseViewController {
    
    private let rootView = SearchView()
    
    let repository = DiaryRepository()
    var tasks: Results<Diary>! { didSet { rootView.tableView.reloadData() }}
    
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureTableView()
        configureSearchBar()
        configureNavigationBar()
    }
}

extension SearchViewController {

    private func configureNavigationBar() {
        title = "기록 검색"
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        rootView.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        tasks = repository.filter(by: keyword)
        view.endEditing(true)
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        rootView.tableView.rowHeight = UITableView.automaticDimension
        rootView.tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks == nil ? 0 : tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.reuseIdentifier) as? DiaryCell else { return UITableViewCell() }
        let image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
        cell.configure(with: tasks[indexPath.row], image: image)
        return cell
    }
}
