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
    private let photoImageView = UIImageView()
    private let maskingTapeImageView = UIImageView()
    private let favoriteButton = UIButton()
    
    private lazy var dateFormatter = DateFormatter().then {
        $0.dateFormat = "yy.MM.dd"
    }
    
    override func configureAttributes() {
        
        self.selectionStyle = .none
        self.backgroundColor = [
            UIColor(red: 189/255, green: 99/255, blue: 99/255, alpha: 1),
            UIColor(red: 87/255, green: 82/255, blue: 118/255, alpha: 1),
            UIColor(red: 82/255, green: 97/255, blue: 100/255, alpha: 1),
            UIColor(red: 221/255, green: 222/255, blue: 162/255, alpha: 1),
            UIColor(red: 66/255, green: 55/255, blue: 77/255, alpha: 1)
        ].randomElement()
        
        dashLineView.do {
            let lineDashPattern: [NSNumber]? = [6, 12, 18, 24]

            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 3
            shapeLayer.lineDashPattern = lineDashPattern
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: 640, y: 0)])
            
            shapeLayer.path = path
            $0.layer.addSublayer(shapeLayer)
        }

        dateLabel.do {
            $0.font = UIFont(name: "GamjaFlower-Regular", size: 13)
            $0.textColor = .white
            $0.textAlignment = .center
        }
        
        diaryTitleLabel.do {
            $0.font = UIFont(name: "GamjaFlower-Regular", size: 15)
            $0.textColor = .white
        }
        
        photoContainerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 4
        }
        
        photoImageView.do {
            $0.backgroundColor = .systemGray6
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        favoriteButton.do {
            $0.setImage(UIImage(systemName: "bookmark"), for: .normal)
            $0.tintColor = .white
        }
        
        maskingTapeImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.image = UIImage(named: "img_tape2")
        }
    }
    
    override func configureLayout() {

        contentView.addSubviews(dashLineView, dateLabel, diaryTitleLabel, photoContainerView, photoImageView, favoriteButton, maskingTapeImageView)
        
        dashLineView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.trailing.equalToSuperview()
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.leading.equalToSuperview().inset(16)
        }
        
        diaryTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(dateLabel.snp.centerY)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.width.height.equalTo(16)
        }
        
        photoContainerView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(5)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(6)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(70)
        }
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalTo(photoContainerView).inset(2)
        }
        
        maskingTapeImageView.snp.makeConstraints {
            $0.leading.equalTo(photoImageView.snp.trailing).inset(45)
            $0.bottom.equalTo(photoImageView.snp.bottom).inset(8)
            $0.width.equalTo(90)
            $0.height.equalTo(24)
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


