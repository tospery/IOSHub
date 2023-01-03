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
import Kingfisher
import HiIOS

class UserViewController: NormalViewController {
    
    lazy var shareButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.isHidden = true
        button.setImage(R.image.ic_native_share(), for: .normal)
        button.rx.tap
            .subscribeNext(weak: self, type(of: self).tapShare)
            .disposed(by: self.disposeBag)
        button.sizeToFit()
        return button
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.isHidden = true
        button.titleLabel?.font = .bold(14)
        button.titleEdgeInsets = .init(top: -10, left: -20, bottom: 0, right: 0)
        button.imageEdgeInsets = .init(top: -10, left: -20, bottom: 0, right: 0)
        button.contentEdgeInsets = .init(top: 10, left: 20, bottom: 0, right: 0)
        button.setTitle(R.string.localizable.follow(), for: .normal)
        button.setTitle(R.string.localizable.unfollow(), for: .selected)
        button.theme.backgroundColor = themeService.attribute { $0.primaryColor }
        button.theme.titleColor(
            from: themeService.attribute { $0.backgroundColor },
            for: .normal
        )
        button.sizeToFit()
        button.layerCornerRadius = button.height / 2.f
        return button
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.shareButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.shareButton.right = self.view.width - 40
        self.shareButton.bottom = self.view.height - 20 - safeArea.bottom
    }
    
    override func fromState(reactor: NormalViewReactor) {
        super.fromState(reactor: reactor)
        reactor.state.map { $0.isFollowed }
            .distinctUntilChanged()
            .bind(to: self.followButton.rx.isSelected)
            .disposed(by: self.disposeBag)
    }
        
    override func handleUser(user: User?, changed: Bool) {
        guard !changed else { return }
        self.shareButton.isHidden = false
        self.navigationBar.removeAllRightButtons()
        if user?.isOrganization ?? false {
            self.navigationBar.addButtonToRight(image: R.image.ic_organization()).rx.tap
                .subscribeNext(weak: self, type(of: self).tapOrganization)
                .disposed(by: self.disposeBag)
        } else {
            self.followButton.isHidden = false
//            self.navigationBar.addButtonToRight(button: self.followButton).rx.tap
//                .subscribeNext(weak: self, type(of: self).tapFollow)
//                .disposed(by: self.disposeBag)
            self.navigationBar.addButtonToRight(button: self.followButton).rx.tap
                .map { Reactor.Action.follow }
                .bind(to: self.reactor!.action)
                .disposed(by: self.disposeBag)
        }
    }
    
    func tapFollow(_: Void? = nil) {
        log("tapFollow")
    }
    
    func tapOrganization(_: Void? = nil) {
        log("tapOrganization")
    }
    
    func tapShare(_: Void? = nil) {
        guard let user = self.reactor?.currentState.user else { return }
        guard let avatar = user.avatar?.url, let html = user.htmlUrl?.url else { return }
        ImageDownloader.default.downloadImage(with: avatar) { result in
            switch result {
            case let .success(value):
                ShareManager.shared.native(
                    title: user.fullnameAttributedText.string,
                    image: value.image,
                    url: html
                )
            case let .failure(error):
                log("下载头像失败：\(error)")
            }
        }
    }
    
}

//extension Reactive where Base: UserViewController {
//
//    var follow: Binder<Bool> {
//        self.base.followButton.rx.isSelected
//    }
//
//}
