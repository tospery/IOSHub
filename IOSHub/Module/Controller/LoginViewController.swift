//
//  LoginViewController.swift
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
import HiIOS

class LoginViewController: ScrollViewController, ReactorKit.View {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .bold(17)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.text = R.string.localizable.loginSlogan()
        label.sizeToFit()
        return label
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = .normal(15)
        button.setTitle(R.string.localizable.loginButtonTitle(), for: .normal)
        button.theme.titleColor(
            from: themeService.attribute { $0.backgroundColor },
            for: .normal
        )
        button.theme.backgroundImage(
            from: themeService.attribute {
                UIImage.init(
                    color: $0.specialColors.color(for: Parameter.login)!,
                    size: .init(width: deviceWidth, height: 50)
                )
            },
            for: .normal
        )
        button.rx.tap
            .subscribeNext(weak: self, type(of: self).tapLogin)
            .disposed(by: self.disposeBag)
        button.sizeToFit()
        button.width = deviceWidth * 0.8
        button.height = 46
        button.layerCornerRadius = 8
        return button
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.appLogo()
        imageView.sizeToFit()
        imageView.size = .init(deviceWidth * 0.3)
        return imageView
    }()
    
    required init(_ navigator: NavigatorProtocol, _ reactor: BaseViewReactor) {
        defer {
            self.reactor = reactor as? LoginViewReactor
        }
        super.init(navigator, reactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.addButtonToRight(title: R.string.localizable.accessToken())
            .rx.tap
            .subscribeNext(weak: self, type(of: self).tapAccessToken)
            .disposed(by: self.disposeBag)
        self.scrollView.addSubview(self.iconImageView)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.loginButton)
        self.navigationBar.theme.rightItemColor = themeService.attribute { $0.primaryColor }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.iconImageView.left = self.iconImageView.leftWhenCenter
        self.iconImageView.top = self.iconImageView.topWhenCenter * 0.7
        self.titleLabel.left = self.titleLabel.leftWhenCenter
        self.titleLabel.top = self.iconImageView.bottom + 10
        self.loginButton.left = self.loginButton.leftWhenCenter
        self.loginButton.bottom = self.scrollView.height - 50 - safeArea.bottom
    }
    
    func bind(reactor: LoginViewReactor) {
        super.bind(reactor: reactor)
        // action
        self.rx.load.map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // state
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.navigationBar.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.rx.loading)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.isActivating }
            .distinctUntilChanged()
            .bind(to: self.rx.activating)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.error }
            .distinctUntilChanged({ $0?.asHiError == $1?.asHiError })
            .bind(to: self.rx.error)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .skip(1)
            .filterNil()
            .subscribeNext(weak: self, type(of: self).handleUser)
            .disposed(by: self.disposeBag)
    }

    func tapLogin(_: Void? = nil) {
        self.navigator.rxSheet(
            R.string.localizable.loginPrivacyTitle(),
            R.string.localizable.loginPrivacyMessage(),
            [
                IHAlertAction.onlyPublic,
                IHAlertAction.withPrivate,
                IHAlertAction.cancel
            ]
        )
        .subscribeNext(weak: self, type(of: self).handleSheet)
        .disposed(by: self.disposeBag)
    }
    
    func tapAccessToken(_: Void? = nil) {
        self.navigator.rxAlert(
            R.string.localizable.loginPersonalToken(),
            R.string.localizable.loginPrivacyMessage(),
            [
                IHAlertAction.input,
                IHAlertAction.cancel,
                IHAlertAction.default
            ]
        )
        .subscribeNext(weak: self, type(of: self).handleAlert)
        .disposed(by: self.disposeBag)
    }
    
    func handleAlert(token: Any) {
        guard let token = token as? String, !token.isEmpty else { return }
        self.login()
    }
    
    func handleSheet(action: Any) {
        guard let action = action as? IHAlertAction, action != .cancel else { return }
        self.login()
    }
    
    func login() {
        MainScheduler.asyncInstance.schedule(()) { [weak self] _ -> Disposable in
            guard let `self` = self else { fatalError() }
            self.reactor?.action.onNext(.login)
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
    }
    
    func handleUser(user: User) {
        log("login success")
        Subjection.update(AccessToken.self, self.reactor?.currentState.accessToken)
        MainScheduler.asyncInstance.schedule(()) { _ -> Disposable in
            User.update(user, reactive: true)
            return Disposables.create {}
        }.disposed(by: self.disposeBag)
        self.close()
    }
    
}
