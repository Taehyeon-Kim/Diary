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

    private let dashLineView = UIView()
    private let dateLabel = UILabel()
    private let diaryTitleLabel = UILabel()
    private let photoContainerView = UIView()
    let photoImageView = UIImageView()
    private let maskingTapeImageView = UIImageView()
    private let favoriteButton = UIButton()
    
    private lazy var dateFormatter = DateFormatter().then {
        $0.dateFormat = "yy.MM.dd"
    }
    
    override func configureAttributes() {
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        dashLineView.do {
            let lineDashPattern: [NSNumber]? = [6, 12, 18, 24]

            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1).cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = lineDashPattern
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: 640, y: 0)])
            
            shapeLayer.path = path
            $0.layer.addSublayer(shapeLayer)
        }

        dateLabel.do {
            $0.font = UIFont(name: "GamjaFlower-Regular", size: 24)
            $0.textColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1)
            $0.textAlignment = .center
        }
        
        diaryTitleLabel.do {
            $0.font = UIFont(name: "GamjaFlower-Regular", size: 17)
            $0.textColor = UIColor(red: 127/255, green: 132/255, blue: 135/255, alpha: 1)
        }

        photoImageView.do {
            $0.backgroundColor = .systemGray6
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
        }
        
        favoriteButton.do {
            $0.setImage(UIImage(systemName: "bookmark"), for: .normal)
            $0.tintColor = UIColor(red: 63/255, green: 78/255, blue: 79/255, alpha: 1)
        }
        
        maskingTapeImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.image = UIImage(named: "img_tape2")
        }
    }
    
    override func configureLayout() {

        contentView.addSubviews(dashLineView, dateLabel, diaryTitleLabel, photoContainerView, photoImageView, favoriteButton, maskingTapeImageView)
        
        photoImageView.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(16)
        }
        
        dashLineView.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.top).offset(4)
            $0.leading.equalTo(photoImageView.snp.trailing).offset(12)
        }
        
        diaryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(4)
            $0.leading.equalTo(photoImageView.snp.trailing).offset(12)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.top).offset(2)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(16)
        }

        maskingTapeImageView.snp.makeConstraints {
            $0.leading.equalTo(photoImageView.snp.trailing).inset(45)
            $0.bottom.equalTo(photoImageView.snp.bottom).inset(8)
            $0.width.equalTo(90)
            $0.size.equalTo(24)
        }
    }
}

extension DiaryCell {
    
    func configure(with diary: Diary, image: UIImage?) {
        dateLabel.text = dateFormatter.string(from: diary.diaryDate)
        photoImageView.image = image
        diaryTitleLabel.text = diary.diaryTitle
    }
}


