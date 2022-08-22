//
//  WriteView.swift
//  DDAK
//
//  Created by taekki on 2022/08/22.
//

import UIKit

import DDAK_Core
import SnapKit
import Then

final class WriteView: BaseView {
    
    lazy var maskingTapeImageView = UIImageView()
    lazy var containerImageView = UIImageView()
    lazy var photoImageView = UIImageView()
    lazy var selectPhotoButton = UIButton()
    lazy var titleTextField = UITextField()
    lazy var contentTextView = UITextView()
    
    override func configureAttributes() {
        self.backgroundColor = .systemBackground
        
        containerImageView.do {
            $0.backgroundColor = .black
        }
        
        maskingTapeImageView.do {
            $0.backgroundColor = .blue
        }
        
        photoImageView.do {
            $0.backgroundColor = .white
        }
        
        selectPhotoButton.do {
            $0.backgroundColor = .blue
        }
        
        titleTextField.do {
            $0.backgroundColor = .white
        }
        
        titleTextField.do {
            $0.backgroundColor = .white
        }
    }
    
    override func configureLayout() {
        
        self.addSubviews(
            containerImageView,
            maskingTapeImageView,
            photoImageView,
            selectPhotoButton,
            titleTextField,
            contentTextView
        )
        
        containerImageView.snp.makeConstraints {
            $0.leadingMargin.trailingMargin.equalTo(20)
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.center.equalToSuperview()
        }
        
        maskingTapeImageView.snp.makeConstraints {
            $0.width.equalTo(containerImageView).multipliedBy(0.3)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(containerImageView.snp.top)
        }
        
        photoImageView.snp.makeConstraints {
            $0.height.equalTo(containerImageView).multipliedBy(0.6)
            $0.top.equalTo(containerImageView).inset(20)
            $0.leading.trailing.equalTo(containerImageView).inset(16)
        }
        
        selectPhotoButton.snp.makeConstraints {
            $0.trailing.equalTo(photoImageView.snp.trailing).offset(-12)
            $0.bottom.equalTo(photoImageView.snp.bottom).offset(-12)
            $0.width.height.equalTo(40)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(containerImageView).inset(16)
            $0.height.equalTo(40)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(16)
            $0.bottom.equalTo(containerImageView.snp.bottom).inset(16)
            $0.leading.trailing.equalTo(containerImageView).inset(16)
        }
    }
}
