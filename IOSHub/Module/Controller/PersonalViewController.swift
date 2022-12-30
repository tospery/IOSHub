//
//  PersonalViewController.swift
//  IOSHub
//
//  Created by 杨建祥 on 2020/11/28.
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
import MXParallaxHeader
import HiIOS

class PersonalViewController: NormalViewController {
    
    lazy var parallaxView: PersonalParallaxView = {
        let parallaxView = PersonalParallaxView.init(frame: .zero)
        parallaxView.translatesAutoresizingMaskIntoConstraints = false
        parallaxView.sizeToFit()
        parallaxView.rx.tapUser
            .subscribeNext(weak: self, type(of: self).tapUser)
            .disposed(by: self.rx.disposeBag)
//        parallaxView.rx.tapTheme
//            .subscribeNext(weak: self, type(of: self).tapTheme)
//            .disposed(by: self.rx.disposeBag)
        parallaxView.rx.tapRepositories
            .subscribeNext(weak: self, type(of: self).tapRepositories)
            .disposed(by: self.rx.disposeBag)
        parallaxView.rx.tapFollower
            .subscribeNext(weak: self, type(of: self).tapFollower)
            .disposed(by: self.rx.disposeBag)
        parallaxView.rx.tapFollowing
            .subscribeNext(weak: self, type(of: self).tapFollowing)
            .disposed(by: self.rx.disposeBag)
        return parallaxView
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.parallaxHeader.view = self.parallaxView
        self.collectionView.parallaxHeader.height = self.parallaxView.height
        self.collectionView.parallaxHeader.minimumHeight = self.parallaxView.height
        self.collectionView.parallaxHeader.mode = .topFill
        self.parallaxView.widthAnchor.constraint(equalTo: self.collectionView.widthAnchor).isActive = true
        self.navigationBar.theme.titleColor = themeService.attribute { $0.backgroundColor }
        self.collectionView.rx.didEndDragging
            .subscribeNext(weak: self, type(of: self).didEndDragging)
            .disposed(by: self.disposeBag)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarService.value.reversed
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func bind(reactor: NormalViewReactor) {
        super.bind(reactor: reactor)
        // swiftlint:disable:next force_cast
        self.parallaxView.bind(reactor: reactor as! PersonalViewReactor)
    }
    
    override func fromState(reactor: NormalViewReactor) {
        super.fromState(reactor: reactor)
    }
    
    func tapUser(_: Void? = nil) {
        if self.reactor?.currentState.user?.isValid ?? false {
            self.navigator.forward(Router.shared.urlString(host: .profile))
            return
        }
        self.navigator.login()
    }
    
    func tapTheme(_: Void? = nil) {
        log("tapTheme")
        // themeService.type.toggle(.primary)
    }
    
    func tapRepositories(_: Void? = nil) {
        self.navigator.forward(Router.shared.urlString(host: .stars))
    }
    
    func tapFollower(_: Void? = nil) {
        log("tapShare")
    }
    
    func tapFollowing(_: Void? = nil) {
        log("tapBrowse")
    }
    
    func didEndDragging(isEnd: Bool) {
        let triggerOffset = Metric.Personal.parallaxAllHeight / standardWidth * deviceWidth + 50
        guard self.scrollView.contentOffset.y < triggerOffset * -1 else { return }
        MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
            guard let `self` = self else { fatalError() }
            self.reactor?.action.onNext(.reload(nil))
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }

}
