//
//  PhotoSearchView.swift
//  DDAK
//
//  Created by taekki on 2022/08/22.
//

import UIKit

import DDAK_Core
import SnapKit
import Then

final class PhotoSearchView: BaseView {
    
    lazy var searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func configureAttributes() {
        
        self.backgroundColor = .systemBackground
        
        searchBar.do {
            $0.placeholder = "사진을 검색해보세요."
            $0.searchTextField.font = .systemFont(ofSize: 14)
            $0.searchTextField.backgroundColor = .clear
        }
        
        collectionView.do {
            $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
            
            let layout = UICollectionViewFlowLayout()
            let spacing = 8.0
            let cellWidth = (UIScreen.main.bounds.width - spacing * 2) / 3
            layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            layout.minimumInteritemSpacing = spacing
            $0.collectionViewLayout = layout
        }
    }
    
    override func configureLayout() {
        
        addSubviews(searchBar, collectionView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
