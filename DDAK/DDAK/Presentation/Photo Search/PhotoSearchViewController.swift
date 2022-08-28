//
//  PhotoSearchViewController.swift
//  DDAK
//
//  Created by taekki on 2022/08/22.
//

import UIKit

import DDAK_Core
import DDAK_Network
import SnapKit
import Then

final class PhotoSearchViewController: BaseViewController {
    
    private let photoSearchView = PhotoSearchView()
     
    private var imageStrings: [String] = []
    private var selectedImage: UIImage?
    private var selectedIndexPath: IndexPath?
    var selectionCompletionHandler: ((UIImage) -> ())?
    
    override func loadView() {
        self.view = photoSearchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchImage(query: "sea")
    }
    
    override func configureAttributes() {
        super.configureAttributes()
        
        configureCollectionView()
        configureSearchBar()
        configureNavigationBar()
    }
}

extension PhotoSearchViewController {
    
    private func searchImage(query: String, page: Int = 1, perPage: Int = 30) {
        
        PhotoAPIManager.shared.searchImage(query: query, page: page, perPage: perPage) { imageStrings in
            self.imageStrings = imageStrings
            self.photoSearchView.collectionView.reloadData()
        }
    }
    
    private func configureNavigationBar() {
        title = "이미지 검색"
        
        let xmarkButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissController))
        xmarkButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = xmarkButtonItem
        
        let selectButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectImage))
        navigationItem.rightBarButtonItem = selectButtonItem
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true)
    }
    
    @objc func selectImage() {
        guard let selectedImage = selectedImage else {
            presentAlert(title: "사진을 선택해주세요.")
            return
        }
        selectionCompletionHandler?(selectedImage)
        dismissController()
    }
}

extension PhotoSearchViewController: UISearchBarDelegate {
    
    private func configureSearchBar() {
        photoSearchView.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        searchImage(query: keyword)
        view.endEditing(true)
    }
}

extension PhotoSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        photoSearchView.collectionView.delegate = self
        photoSearchView.collectionView.dataSource = self
        photoSearchView.collectionView.backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }

        cell.layer.borderWidth = selectedIndexPath == indexPath ? 4 : 0
        cell.layer.borderColor = selectedIndexPath == indexPath ? UIColor.yellow.cgColor : nil
        
        cell.configure(withImage: imageStrings[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
        selectedImage = cell.photoImageView.image
        
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndexPath = nil
        selectedImage = nil
        collectionView.reloadData()
    }
}
