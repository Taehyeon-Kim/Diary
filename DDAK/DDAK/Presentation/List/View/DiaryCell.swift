//
//  DiaryCell.swift
//  DDAK
//
//  Created by taekki on 2022/08/23.
//

import UIKit

import DDAK_Core
import Kingfisher
import SnapKit
import Then

final class DiaryCell: BaseTableViewCell {
    
    private let dateLabel = UILabel()
    private let photoImageView = UIImageView()
    private let diaryTitleLabel = UILabel()
    private let diaryContentLabel = UILabel()
    
    private lazy var dateFormatter = DateFormatter().then {
        $0.dateFormat = "dd(E)"
    }
    
    override func configureAttributes() {
        
        self.selectionStyle = .none
        
        dateLabel.do {
            $0.font = .boldSystemFont(ofSize: 20)
        }
        
        photoImageView.do {
            $0.backgroundColor = .systemGray6
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
        }
        
        diaryTitleLabel.do {
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
        }
    }
    
    override func configureLayout() {

        self.addSubviews(dateLabel, photoImageView, diaryTitleLabel, diaryContentLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(60)                                                                
        }
        
        photoImageView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(20)
        }
        
        diaryTitleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(photoImageView).inset(20)
            $0.trailing.greaterThanOrEqualTo(photoImageView).inset(20)
        }
    }
}

extension DiaryCell {
    
    func configure(with diary: Diary) {
        dateLabel.text = dateFormatter.string(from: diary.diaryDate)
        photoImageView.kf.setImage(with: URL(string: diary.photoURLString ?? ""))
        diaryTitleLabel.text = diary.diaryTitle
    }
}


