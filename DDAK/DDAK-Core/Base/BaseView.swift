//
//  BaseView.swift
//  DDAK-Core
//
//  Created by taekki on 2022/08/22.
//

import UIKit

open class BaseView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        Logger.log(type(of: self), .info, "init")
        
        configureAttributes()
        configureLayout()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        Logger.log(type(of: self), .info, "required init")
    }
    
    open func configureAttributes() {}
    open func configureLayout() {}
}
