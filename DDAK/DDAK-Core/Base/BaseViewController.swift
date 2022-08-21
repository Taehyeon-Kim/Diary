//
//  BaseViewController.swift
//  DDAK-Core
//
//  Created by taekki on 2022/08/22.
//

import Then
import UIKit

open class BaseViewController: UIViewController {

    public override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        Logger.log(type(of: self), .info, "init")
        
        configureAttributes()
        configureLayout()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        Logger.log(type(of: self), .info, "required init")
    }
    
    deinit {
        Logger.log(type(of: self), .info, "deinit")
    }

    open func configureAttributes() {}
    open func configureLayout() {}
}
