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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func handleUser(user: User?, changed: Bool) {
        log("独立的User -> \(changed)")
        // self.handleUser(user: user, changed: true)
        guard !changed else { return }
        self.navigationBar.removeAllRightButtons()
        if user?.isOrganization ?? false {
            self.navigationBar.addButtonToRight(image: R.image.ic_organization()).rx.tap
                .subscribeNext(weak: self, type(of: self).tapOrganization)
                .disposed(by: self.disposeBag)
        } else {
            self.navigationBar.addButtonToRight(title: R.string.localizable.follow()).rx.tap
                .subscribeNext(weak: self, type(of: self).tapFollow)
                .disposed(by: self.disposeBag)
        }
    }

    func tapFollow(_: Void? = nil) {
        log("tapFollow")
    }
    
    func tapOrganization(_: Void? = nil) {
        log("tapOrganization")
    }
    
}
