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
import Zip

final class SettingViewController: BaseViewController {
    
    private let settingView = SettingView()
    
    enum SettingOption: String, CaseIterable {
        case backUp = "백업하기"
        case restore = "복구하기"
        case privacy = "개인정보 처리방침"
    }
    private let dataSource = SettingOption.allCases

    override func loadView() {
        self.view = settingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureAttributes() {
        super.configureAttributes()
        
        configureNavigationBar()
        configureTableView()
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureNavigationBar() {
        title = "설정"
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
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
        cell.textLabel?.text = dataSource[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource[indexPath.row] {
        case .backUp:
            backUpData()
        case .restore:
            restoreData()
        default:
            fetchDocumentZipFile()
            return
        }
    }
}

extension SettingViewController {
    
    func backUpData() {
        
        var urlPaths = [URL]()
        
        // - Document 위치에 백업 파일 확인
        guard let documentDirectoryPath = getDocumentDirectoryPath() else {
            presentAlert(title: "Document 위치에 오류가 있습니다.")
            return
        }
        
        // - URL 형태 : Realm File에 대한 것 (세부 경로)
        let realmFilePath = documentDirectoryPath.appendingPathComponent("default.realm")
        
        // realm 파일이 없을 수도 있음 - 사용자가 어떠한 파일도 저장하지 않은 경우
        guard FileManager.default.fileExists(atPath: realmFilePath.path) else {
            presentAlert(title: "백업할 파일이 없습니다.")
            return
        }
        
        urlPaths.append(realmFilePath)
        
        // - 백업 파일을 압축 (경로 기반으로 URL 배열 압축)
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "DDAK_1")
            print("Archive Location: \(zipFilePath)")
            showActivityViewController()
            
        } catch {
            presentAlert(title: "압축을 실패했습니다.")
        }
        
        // - ActivityViewController
        // - 성공을 했을 경우에만 띄우기
        showActivityViewController()
    }
    
    func showActivityViewController() {
        guard let documentDirectoryPath = getDocumentDirectoryPath() else {
            presentAlert(title: "Document 위치에 오류가 있습니다.")
            return
        }
        
        // - URL 형태 : Realm File에 대한 것 (세부 경로)
        let backUpFileURL = documentDirectoryPath.appendingPathComponent("DDAK_1.zip")
        
        let viewController = UIActivityViewController(activityItems: [backUpFileURL], applicationActivities: [])
        self.present(viewController, animated: true)
    }
    
    func restoreData() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
}

extension SettingViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        // 1. 선택한 파일이 있는지 먼저 체크
        guard let selectedFileURL = urls.first else {
            presentAlert(title: "선택하신 파일에 오류가 있습니다.")
            return
        }
        
        // 2. 압축 파일을 저장할 수 있는 도큐먼트 위치 겟
        guard let path = getDocumentDirectoryPath() else {
            presentAlert(title: "Document 위치에 오류가 있습니다.")
            return
        }
        
        // - selectedFileURL.lastPathComponent : "DDAK_1.zip"
        // 3. path의 마지막 경로를 가지고 옴. 즉, 파일의 이름을 가져오기 위함
        let sandBoxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        // 이미 존재하는 파일인지 체크 - 이미 존재한다면 새롭게 저장하고 사용할 필요가 없기 때문
        if FileManager.default.fileExists(atPath: sandBoxFileURL.path) {
            
            let fileURL = path.appendingPathComponent("DDAK_1.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print(progress)
                }, fileOutputHandler: { unzippedFile in
                    print(unzippedFile)
                    self.presentAlert(title: "복구가 완료됐습니다.")
                })
                
            } catch {
                self.presentAlert(title: "복구에 실패했습니다.")
            }
            
        } else {
            
            do {
                // 파일 앱의 zip -> 도큐먼트 폴더에 복사
                try FileManager.default.copyItem(at: selectedFileURL, to: sandBoxFileURL)
                
                let fileURL = path.appendingPathComponent("DDAK_1.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print(progress)
                }, fileOutputHandler: { unzippedFile in
                    print(unzippedFile)
                    self.presentAlert(title: "복구가 완료됐습니다.")
                })
                
            } catch {
                self.presentAlert(title: "복구에 실패했습니다.")
            }
            
        }
    }
}
