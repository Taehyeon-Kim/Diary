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
    var selectionCompletionHandler: ((String) -> ())?
    
    override func loadView() {
        self.view = photoSearchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchImage(query: "sea")
    }
    
    override func configureAttributes() {
        configureCollectionView()
        configureSearchBar()
    }
}

extension PhotoSearchViewController {
    
    private func searchImage(query: String, page: Int = 1, perPage: Int = 30) {
        
        PhotoAPIManager.shared.searchImage(query: query, page: page, perPage: perPage) { imageStrings in
            self.imageStrings = imageStrings
            self.photoSearchView.collectionView.reloadData()
        }
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
        print(imageStrings.count)
        return imageStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.configure(withImage: imageStrings[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionCompletionHandler?(imageStrings[indexPath.row])
        dismiss(animated: true)
    }
}
