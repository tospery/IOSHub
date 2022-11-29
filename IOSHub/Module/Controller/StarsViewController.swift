//
//  StarsViewController.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/29.
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

class StarsViewController: NormalViewController {
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
        self.shouldRefresh = reactor.parameters.bool(for: Parameter.shouldRefresh) ?? true
        self.shouldLoadMore = reactor.parameters.bool(for: Parameter.shouldLoadMore) ?? true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
