//
//  BaseCollectionViewCell.swift
//  DDAK-Core
//
//  Created by taekki on 2022/08/22.
//

import UIKit

open class BaseCollectionViewCell: UICollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
        configureLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func configureAttributes() {}
    open func configureLayout() {}
}
