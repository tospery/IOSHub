//
//  UserViewController.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/30.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import ReusableKit_Hi
import ObjectMapper_Hi
import RxDataSources
import RxGesture
import HiIOS

class UserViewController: NormalViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleUser(user: User?, changed: Bool) {
        log("独立的User -> \(changed)")
    }

}