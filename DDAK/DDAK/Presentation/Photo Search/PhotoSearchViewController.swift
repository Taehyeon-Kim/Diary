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
    
    override func loadView() {
        self.view = photoSearchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchImage(query: "sea")
    }
    
    override func configureAttributes() {
        configureCollectionView()
    }
}

extension PhotoSearchViewController {
    
    private func searchImage(query: String, page: Int = 1) {
        
        PhotoAPIManager.shared.searchImage(query: query) { imageStrings in
            self.imageStrings = imageStrings
            self.photoSearchView.collectionView.reloadData()
        }
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
        cell.configure(withImage: imageStrings[indexPath.row])
        return cell
    }
}
