//
//  PhotoSearchViewController.swift
//  DDAK
//
//  Created by taekki on 2022/08/22.
//

import UIKit

import DDAK_Core
import SnapKit
import Then

final class PhotoSearchViewController: BaseViewController {
    
    private let photoSearchView = PhotoSearchView()
    
    override func loadView() {
        self.view = photoSearchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureAttributes() {
        configureCollectionView()
    }
}

extension PhotoSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        photoSearchView.collectionView.delegate = self
        photoSearchView.collectionView.dataSource = self
        photoSearchView.collectionView.backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}
