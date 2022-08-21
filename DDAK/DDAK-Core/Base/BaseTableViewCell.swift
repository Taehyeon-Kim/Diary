//
//  BaseTableViewCell.swift
//  DDAK-Core
//
//  Created by taekki on 2022/08/22.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
    
    /*
     TableView는 이니셜라이저가 약간 다르다.
     */
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureAttributes()
        configureLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func configureAttributes() {}
    open func configureLayout() {}
}
