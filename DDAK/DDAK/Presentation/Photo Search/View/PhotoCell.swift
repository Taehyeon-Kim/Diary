//
//  PhotoCell.swift
//  DDAK
//
//  Created by taekki on 2022/08/22.
//

import UIKit

import DDAK_Core
import SnapKit
import Then

final class PhotoCell: BaseCollectionViewCell {
    
    private let photoImageView = UIImageView()
    
    override func configureAttributes() {
        
        photoImageView.do {
            $0.backgroundColor = .green
        }
    }
    
    override func configureLayout() {

        self.addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
