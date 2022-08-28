//
//  WriteViewController.swift
//  DDAK
//
//  Created by taekki on 2022/08/22.
//

import UIKit

import DDAK_Core
import DDAK_Network
import PhotosUI
import RealmSwift
import SnapKit
import Then

final class WriteViewController: BaseViewController {
    
    private let writeView = WriteView()

    private let repository: DiaryRepositoryType = DiaryRepository()
    private let realm = try! Realm()
    private var photoURLString: String?
    
    override func loadView() {
        self.view = writeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureNavigationBar()
        writeView.selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
        writeView.titleTextField.delegate = self
        writeView.contentTextView.delegate = self
    }
}

extension WriteViewController {
    
    private func configureNavigationBar() {
        let label = UILabel()
        label.textColor = .black
        label.text = "기록"
        label.font = UIFont(name: "GamjaFlower-Regular", size: 20)
        navigationItem.titleView = label

        let backButton = UIButton(type: .custom)
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        let xmarkButton = UIButton(type: .custom)
        xmarkButton.tintColor = .black
        xmarkButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xmarkButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        xmarkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let xmarkButtonItem = UIBarButtonItem(customView: xmarkButton)
        
        let writeButton = UIButton(type: .custom)
        writeButton.tintColor = .black
        writeButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        writeButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        writeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let writeButtonItem = UIBarButtonItem(customView: writeButton)
        
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItems = [xmarkButtonItem, writeButtonItem]
    }
    
    @objc func backButtonTapped() {
        self.presentAlert(title: "그만 작성하실래요?", isCancelActionIncluded: true) { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func selectPhotoButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "사진 검색", style: .default, handler: { [weak self] _ in
            let photoSearchViewController = PhotoSearchViewController()
            photoSearchViewController.selectionCompletionHandler = { photo in
                self?.writeView.photoImageView.image = photo
            }
            self?.transition(photoSearchViewController, transitionStyle: .push)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "사진 촬영", style: .default, handler: { [weak self] _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return
            }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.transition(picker, transitionStyle: .present)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "갤러리", style: .default, handler: { [weak self] _ in
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self?.transition(picker, transitionStyle: .present)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        transition(actionSheet, transitionStyle: .present)
    }
    
    @objc func saveButtonTapped() {
        
        guard let title = writeView.titleTextField.text else {
            self.presentAlert(title: "제목을 입력해주세요")
            return
        }

        repository.write(
            photoURLString: photoURLString ?? "",
            diaryTitle: title,
            diaryContent: writeView.contentTextView.text,
            diaryDate: Date(),
            createdAt: Date()
        ) { diary in
            if let image = self.writeView.photoImageView.image {
                self.saveImageToDocument(fileName: "\(diary.objectId).jpg", image: image)
            }
            
            self.presentAlert(title: "📩 성공적으로 저장되었어요.") { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension WriteViewController: UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.writeView.photoImageView.image = image
            dismiss(animated: true)
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.sync { [weak self] in
                    self?.writeView.photoImageView.image = image as? UIImage
                }
            }
        }
    }
}

extension WriteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension WriteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      if (text == "\n") {
        textView.resignFirstResponder()
      }
      return true
    }
}
