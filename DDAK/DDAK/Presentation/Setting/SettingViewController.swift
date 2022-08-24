//
//  SettingViewController.swift
//  DDAK
//
//  Created by taekki on 2022/08/25.
//

import UIKit

import DDAK_Core
import DDAK_Network
import SnapKit
import Then

final class SettingViewController: BaseViewController {
    
    private let settingView = SettingView()
    
    private let dataSource = ["백업하기", "복구하기", "개인정보 처리방침"]

    override func loadView() {
        self.view = settingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureAttributes() {
        title = "설정"
        configureTableView()
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        settingView.tableView.delegate = self
        settingView.tableView.dataSource = self
        settingView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        settingView.tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "데이터"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.selectionStyle = .none
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}
