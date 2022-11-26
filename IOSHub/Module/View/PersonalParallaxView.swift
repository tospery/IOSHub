//
//  PersonalParallaxView.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import BonMot
import RxGesture
import SnapKit
import HiIOS

class PersonalParallaxView: UIImageView {
    
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.personal_parallax_bg()
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var userView: UIView = {
        let view = UIView.init(frame: .zero)
        view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        view.sizeToFit()
        view.layerCornerRadius = 6
        return view
    }()
    
    lazy var infoView: UIView = {
        let view = UIView.init(frame: .zero)
        view.isUserInteractionEnabled = true
        view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        view.sizeToFit()
        return view
    }()
    
    lazy var statView: UIView = {
        let view = UIView.init(frame: .zero)
        view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        view.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        view.sizeToFit()
        view.qmui_borderPosition = .top
        view.qmui_borderWidth = pixelOne
        view.qmui_borderInsets = .init(horizontal: 30, vertical: 0)
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.user_default()
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .bold(18)
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.text = R.string.localizable.clickToLogin()
        label.sizeToFit()
        return label
    }()

    lazy var descLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.attributedText = R.string.localizable.appSlogan()
            .styled(with: .font(.normal(13)), .color(.body))
        label.sizeToFit()
        return label
    }()
    
    lazy var repositoriesButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.setAttributedTitle(
            .composed(of: [
                "0".styled(with: .color(.foreground), .font(.bold(22))),
                Special.nextLine,
                R.string.localizable.repositores().styled(with: .color(.body), .font(.normal(13)))
            ]).styled(with: .lineSpacing(4), .alignment(.center)),
            for: .normal
        )
        button.sizeToFit()
        return button
    }()

    lazy var followerButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.setAttributedTitle(
            .composed(of: [
                "0".styled(with: .color(.foreground), .font(.bold(22))),
                Special.nextLine,
                R.string.localizable.followers().styled(with: .color(.body), .font(.normal(13)))
            ]).styled(with: .lineSpacing(4), .alignment(.center)),
            for: .normal
        )
        button.sizeToFit()
        return button
    }()

    lazy var followingButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.setAttributedTitle(
            .composed(of: [
                "0".styled(with: .color(.foreground), .font(.bold(22))),
                Special.nextLine,
                R.string.localizable.following().styled(with: .color(.body), .font(.normal(13)))
            ]).styled(with: .lineSpacing(4), .alignment(.center)),
            for: .normal
        )
        button.sizeToFit()
        return button
    }()

//    lazy var themeButton: UIButton = {
//        let button = UIButton.init(type: .custom)
//        button.setImage(R.image.navbar_theme_light(), for: .normal)
//        button.setImage(R.image.navbar_theme_dark(), for: .selected)
//        button.sizeToFit()
//        return button
//    }()

    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
        view.sizeToFit()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.theme.backgroundColor = themeService.attribute { $0.lightColor }
        self.addSubview(self.topImageView)
        self.topImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(
                Metric.Personal.parallaxTopHeight / Metric.Personal.parallaxAllHeight
            )
        }
        self.addSubview(self.userView)
        self.userView.snp.makeConstraints { make in
            make.width.equalTo(deviceWidth - 20 * 2)
            make.height.equalTo(self.userView.snp.width).multipliedBy(0.46)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.94)
        }
        self.userView.addSubview(self.infoView)
        self.userView.addSubview(self.statView)
        self.infoView.addSubview(self.iconImageView)
        self.infoView.addSubview(self.nameLabel)
        self.infoView.addSubview(self.descLabel)
        self.statView.addSubview(self.repositoriesButton)
        self.statView.addSubview(self.followerButton)
        self.statView.addSubview(self.followingButton)
        // self.addSubview(self.themeButton)
        self.addSubview(self.activityIndicatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.statView.height = self.userView.width / 5.5
        self.statView.width = self.userView.width
        self.statView.left = 0
        self.statView.bottom = self.userView.height
        self.infoView.width = self.userView.width
        self.infoView.height = self.statView.top
        self.infoView.left = 0
        self.infoView.top = 0
        self.iconImageView.height = self.infoView.height * 0.7
        self.iconImageView.width = self.iconImageView.height
        self.iconImageView.layerCornerRadius = self.iconImageView.height / 2.0
        self.iconImageView.left = 20
        self.iconImageView.top = self.iconImageView.topWhenCenter + 4
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.iconImageView.right + 10
        self.nameLabel.bottom = self.iconImageView.centerY
        self.descLabel.sizeToFit()
        self.descLabel.left = self.nameLabel.left
        self.descLabel.top = self.nameLabel.bottom + 5
        self.repositoriesButton.width = self.statView.width / 3.0
        self.repositoriesButton.height = self.statView.height
        self.repositoriesButton.left = 0
        self.repositoriesButton.top = 0
        self.followerButton.size = self.repositoriesButton.size
        self.followerButton.left = self.repositoriesButton.right
        self.followerButton.top = 0
        self.followingButton.size = self.repositoriesButton.size
        self.followingButton.left = self.followerButton.right
        self.followingButton.top = 0
        self.activityIndicatorView.left = self.activityIndicatorView.leftWhenCenter
        self.activityIndicatorView.top = self.userView.top - 35
//        self.themeButton.right = self.userView.right
//        self.themeButton.bottom = self.userView.top - 20
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: deviceWidth, height: Metric.Personal.parallaxAllHeight / standardWidth * deviceWidth)
    }
    
    func bind(reactor: PersonalViewReactor) {
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.rx.refreshing)
            .disposed(by: self.rx.disposeBag)
        reactor.state.map { $0.user?.avatarUrl?.imageSource }
            .distinctUntilChanged { HiIOS.compareImage($0, $1) }
            .bind(to: self.iconImageView.rx.imageResource(placeholder: R.image.user_default()))
            .disposed(by: self.rx.disposeBag)
        reactor.state.map {
            $0.user?.username ?? R.string.localizable.clickToLogin()
        }
            .distinctUntilChanged()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.rx.disposeBag)
        reactor.state.map {
            ($0.user?.joinedOn ?? R.string.localizable.appSlogan())
                .styled(with: .font(.normal(13)), .color(.body))
        }
            .distinctUntilChanged()
            .bind(to: self.descLabel.rx.attributedText)
            .disposed(by: self.rx.disposeBag)
        reactor.state.map { $0.user?.repositoresText }
            .distinctUntilChanged()
            .bind(to: self.repositoriesButton.rx.attributedTitle(for: .normal))
            .disposed(by: self.rx.disposeBag)
        reactor.state.map { $0.user?.followersText }
            .distinctUntilChanged()
            .bind(to: self.followerButton.rx.attributedTitle(for: .normal))
            .disposed(by: self.rx.disposeBag)
        reactor.state.map { $0.user?.followingText }
            .distinctUntilChanged()
            .bind(to: self.followingButton.rx.attributedTitle(for: .normal))
            .disposed(by: self.rx.disposeBag)
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.rx.disposeBag)
    }
    
}

extension Reactive where Base: PersonalParallaxView {
    
    var refreshing: Binder<Bool> {
        return Binder(self.base) { view, isRefreshing in
            if isRefreshing {
                view.activityIndicatorView.startAnimating()
            } else {
                view.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    var tapUser: ControlEvent<Void> {
        let source = base.infoView.rx.tapGesture().when(.recognized).map { _ in }
        return ControlEvent(events: source)
    }
    
//    var tapTheme: ControlEvent<Void> {
//        self.base.themeButton.rx.tap
//    }
    
    var tapRepositories: ControlEvent<Void> {
        self.base.repositoriesButton.rx.tap
    }
    
    var tapFollower: ControlEvent<Void> {
        self.base.followerButton.rx.tap
    }
    
    var tapFollowing: ControlEvent<Void> {
        self.base.followingButton.rx.tap
    }
    
}
