//
//  PhotoCell.swift
//  DDAK
//
//  Created by taekki on 2022/08/22.
//

import UIKit

import DDAK_Core
import Kingfisher
import SnapKit
import Then

final class PhotoCell: BaseCollectionViewCell {
    
    let photoImageView = UIImageView()
    
    override func configureAttributes() {
        
        photoImageView.do {
            $0.backgroundColor = .lightGray
        }
    }
    
    override func configureLayout() {

        self.addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension PhotoCell {
    
    func configure(withImage imageString: String) {
        photoImageView.kf.setImage(with: URL(string: imageString))
    }
}
