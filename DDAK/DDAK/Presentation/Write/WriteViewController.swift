//
//  WriteViewController.swift
//  DDAK
//
//  Created by taekki on 2022/08/22.
//

import UIKit

import DDAK_Core
import DDAK_Network
import SnapKit
import Then

final class WriteViewController: BaseViewController {
    
    private let writeView = WriteView()
    
    override func loadView() {
        self.view = writeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureAttributes() {

    }
}
