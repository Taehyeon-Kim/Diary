//
//  WriteViewController.swift
//  DDAK
//
//  Created by taekki on 2022/08/22.
//

import UIKit

import DDAK_Core
import DDAK_Network
import SnapKit
import Then
import RealmSwift

final class WriteViewController: BaseViewController {
    
    private let writeView = WriteView()
    
    private let realm = try! Realm()
    
    override func loadView() {
        self.view = writeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    override func configureAttributes() {
        writeView.selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
        writeView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
}

extension WriteViewController {
    
    @objc func selectPhotoButtonTapped() {
        let photoSearchViewController = PhotoSearchViewController()
        present(photoSearchViewController, animated: true)
    }
    
    @objc func saveButtonTapped() {
        
        guard let title = writeView.titleTextField.text else { return }
        
        let diary = Diary(
            photoURLString: nil,
            diaryTitle: title,
            diaryContent: writeView.contentTextView.text,
            diaryDate: Date()
        )
        
        try! realm.write {
            realm.add(diary)
            Logger.log(diary)
        }
    }
}
