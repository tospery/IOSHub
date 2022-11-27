//
//  ProfileViewController.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/27.
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

class ProfileViewController: NormalViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tapItem(sectionItem: SectionItem) {
        switch sectionItem {
        case let .simple(item):
            guard let target = (item.model as? Simple)?.target, target.isNotEmpty else { return }
            self.navigator.rxForward(target)
                .subscribe(onNext: { [weak self] result in
                    guard let `self` = self else { return }
                    guard let action = result as? IHAlertAction else { return }
                    if action == IHAlertAction.exit {
                        Subjection.update(AccessToken.self, nil)
                        User.update(nil, reactive: true)
                        self.close()
                    }
                }).disposed(by: self.disposeBag)
        default: break
        }
    }

}
