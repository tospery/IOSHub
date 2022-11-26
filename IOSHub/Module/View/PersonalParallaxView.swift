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

// swiftlint:disable type_body_length
class PersonalParallaxView: UIImageView {
    
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.personal_parallax_bg()
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var centerView: UIView = {
        let view = UIView.init(frame: .zero)
        view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        view.sizeToFit()
        view.layerCornerRadius = 6
        return view
    }()
//
//    lazy var userView: UIView = {
//        let view = UIView.init(frame: .zero)
//        view.isUserInteractionEnabled = true
//        view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
//        view.sizeToFit()
//        view.width = deviceWidth - 20 * 2
//        view.layerCornerRadius = 10
//        return view
//    }()
//
//    lazy var infoView: UIView = {
//        let view = UIView.init(frame: .zero)
//        view.isUserInteractionEnabled = true
//        view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
//        view.sizeToFit()
//        return view
//    }()
//
//    lazy var statView: UIView = {
//        let view = UIView.init(frame: .zero)
//        view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
//        view.sizeToFit()
//        return view
//    }()
//
//    lazy var repositoryButton: UIButton = {
//        let button = UIButton.init(type: .custom)
//        button.titleLabel?.numberOfLines = 2
//        button.setAttributedTitle(
//            .composed(of: [
//                "0".styled(with: .color(.foreground), .font(.bold(22))),
//                Special.nextLine,
//                R.string.localizable.repositores().styled(with: .color(.body), .font(.normal(13)))
//            ]).styled(with: .lineSpacing(4), .alignment(.center)),
//            for: .normal
//        )
//        button.sizeToFit()
//        return button
//    }()
//
//    lazy var followerButton: UIButton = {
//        let button = UIButton.init(type: .custom)
//        button.titleLabel?.numberOfLines = 2
//        button.setAttributedTitle(
//            .composed(of: [
//                "0".styled(with: .color(.foreground), .font(.bold(22))),
//                Special.nextLine,
//                R.string.localizable.followers().styled(with: .color(.body), .font(.normal(13)))
//            ]).styled(with: .lineSpacing(4), .alignment(.center)),
//            for: .normal
//        )
//        button.sizeToFit()
//        return button
//    }()
//
//    lazy var followingButton: UIButton = {
//        let button = UIButton.init(type: .custom)
//        button.titleLabel?.numberOfLines = 2
//        button.setAttributedTitle(
//            .composed(of: [
//                "0".styled(with: .color(.foreground), .font(.bold(22))),
//                Special.nextLine,
//                R.string.localizable.followers().styled(with: .color(.body), .font(.normal(13)))
//            ]).styled(with: .lineSpacing(4), .alignment(.center)),
//            for: .normal
//        )
//        button.sizeToFit()
//        return button
//    }()
//
//    lazy var iconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = R.image.default_avatar()
//        imageView.sizeToFit()
//        imageView.size = .init(metric(60))
//        imageView.layerCornerRadius = imageView.width / 2.0
//        return imageView
//    }()
//
//    lazy var nameLabel: UILabel = {
//        let label = UILabel.init(frame: .zero)
//        label.font = .bold(18)
//        label.theme.textColor = themeService.attribute { $0.titleColor }
//        label.text = R.string.localizable.clickToLogin()
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var descLabel: UILabel = {
//        let label = UILabel.init(frame: .zero)
//        label.attributedText = R.string.localizable.appSlogan()
//            .styled(with: .font(.normal(13)), .color(.body))
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var themeButton: UIButton = {
//        let button = UIButton.init(type: .custom)
//        button.setImage(R.image.navbar_theme_light(), for: .normal)
//        button.setImage(R.image.navbar_theme_dark(), for: .selected)
//        button.sizeToFit()
//        return button
//    }()
//
//    lazy var activityIndicatorView: UIActivityIndicatorView = {
//        let view = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
//        view.sizeToFit()
//        return view
//    }()
    
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
        self.addSubview(self.centerView)
        self.centerView.snp.makeConstraints { make in
            make.width.equalTo(deviceWidth - 20 * 2)
            make.height.equalTo(self.centerView.snp.width).multipliedBy(0.46)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.94)
            // make.bottom.equalTo(-20)
            // make.bottom.equalTo(self.snp.height).multipliedBy(0.12)
        }
//        self.addSubview(self.topView)
//        self.addSubview(self.userView)
//        self.addSubview(self.themeButton)
//        self.addSubview(self.activityIndicatorView)
//        self.userView.addSubview(self.infoView)
//        self.userView.addSubview(self.statView)
//        self.statView.addSubview(self.repositoryButton)
//        self.statView.addSubview(self.followerButton)
//        self.statView.addSubview(self.followingButton)
//        self.infoView.addSubview(self.iconImageView)
//        self.infoView.addSubview(self.nameLabel)
//        self.infoView.addSubview(self.descLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.topImageView.left = 0
//        self.topImageView.top = 0
//        self.topView.left = 0
//        self.topView.top = 0
//        self.activityIndicatorView.left = self.activityIndicatorView.leftWhenCenter
//        self.activityIndicatorView.top = self.userView.top - 35
//        self.userView.height = (self.height - statusBarHeight - navigationBarHeight - 10).flat
//        self.userView.left = self.userView.leftWhenCenter
//        self.userView.bottom = self.height
//        self.statView.height = self.userView.width / 5.5
//        self.statView.width = self.userView.width
//        self.statView.left = 0
//        self.statView.bottom = self.userView.height
//        self.repositoryButton.width = self.statView.width / 3.0
//        self.repositoryButton.height = self.statView.height
//        self.repositoryButton.left = 0
//        self.repositoryButton.top = 0
//        self.followerButton.size = self.repositoryButton.size
//        self.followerButton.left = self.repositoryButton.right
//        self.followerButton.top = 0
//        self.followingButton.size = self.repositoryButton.size
//        self.followingButton.left = self.followerButton.right
//        self.followingButton.top = 0
//        self.infoView.width = self.userView.width
//        self.infoView.height = self.statView.top
//        self.infoView.left = 0
//        self.infoView.top = 0
//        self.iconImageView.left = 20
//        self.iconImageView.top = self.iconImageView.topWhenCenter + 4
//        self.nameLabel.sizeToFit()
//        self.nameLabel.left = self.iconImageView.right + 10
//        self.nameLabel.bottom = self.iconImageView.centerY
//        self.descLabel.sizeToFit()
//        self.descLabel.left = self.nameLabel.left
//        self.descLabel.top = self.nameLabel.bottom + 5
//        self.themeButton.right = self.userView.right
//        self.themeButton.bottom = self.userView.top - 20
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: deviceWidth, height: Metric.Personal.parallaxAllHeight / standardWidth * deviceWidth)
    }
    
    // swiftlint:disable function_body_length
    func bind(reactor: PersonalViewReactor) {
//        reactor.state.map { $0.isRefreshing }
//            .distinctUntilChanged()
//            .bind(to: self.rx.refreshing)
//            .disposed(by: self.rx.disposeBag)
//        reactor.state.map { $0.user?.avatarUrl?.imageSource }
//            .distinctUntilChanged { HiSwift.compareImage($0, $1) }
//            .bind(to: self.iconImageView.rx.imageResource(placeholder: R.image.default_avatar()))
//            .disposed(by: self.rx.disposeBag)
//        reactor.state.map {
//            $0.user?.username ?? R.string.localizable.clickToLogin()
//        }
//            .distinctUntilChanged()
//            .bind(to: self.nameLabel.rx.text)
//            .disposed(by: self.rx.disposeBag)
//        reactor.state.map {
//            ($0.user?.joinedOn ?? R.string.localizable.appSlogan())
//                .styled(with: .font(.normal(13)), .color(.body))
//        }
//            .distinctUntilChanged()
//            .bind(to: self.descLabel.rx.attributedText)
//            .disposed(by: self.rx.disposeBag)
//        reactor.state.map { $0.user?.publicRepos ?? 0 }
//            .distinctUntilChanged()
//            .map { [weak self] count -> NSAttributedString? in
//                guard let `self` = self else { return nil }
//                return self.stat(R.string.localizable.repositores(), count)
//            }
//            .bind(to: self.repositoryButton.rx.attributedTitle(for: .normal))
//            .disposed(by: self.rx.disposeBag)
//        reactor.state.map { $0.user?.followers ?? 0 }
//            .distinctUntilChanged()
//            .map { [weak self] count -> NSAttributedString? in
//                guard let `self` = self else { return nil }
//                return self.stat(R.string.localizable.followers(), count)
//            }
//            .bind(to: self.followerButton.rx.attributedTitle(for: .normal))
//            .disposed(by: self.rx.disposeBag)
//        reactor.state.map { $0.user?.following ?? 0 }
//            .distinctUntilChanged()
//            .map { [weak self] count -> NSAttributedString? in
//                guard let `self` = self else { return nil }
//                return self.stat(R.string.localizable.following(), count)
//            }
//            .bind(to: self.followingButton.rx.attributedTitle(for: .normal))
//            .disposed(by: self.rx.disposeBag)
//        reactor.state.map { $0.user }
//            .distinctUntilChanged()
//            .map { _ in }
//            .bind(to: self.rx.setNeedsLayout)
//            .disposed(by: self.rx.disposeBag)
    }
    // swiftlint:enable function_body_length
    
//    func stat(_ text: String, _ count: Int) -> NSAttributedString {
//        .composed(of: [
//            count.string.styled(with: .color(.foreground), .font(.bold(22))),
//            Special.nextLine,
//            text.styled(with: .color(.body), .font(.normal(13)))
//        ]).styled(with: .lineSpacing(4), .alignment(.center))
//    }
    
}

extension Reactive where Base: PersonalParallaxView {
    
//    var refreshing: Binder<Bool> {
//        return Binder(self.base) { view, isRefreshing in
//            if isRefreshing {
//                view.activityIndicatorView.startAnimating()
//            } else {
//                view.activityIndicatorView.stopAnimating()
//            }
//        }
//    }
//    
//    var tapUser: ControlEvent<Void> {
//        let source = base.infoView.rx.tapGesture().when(.recognized).map { _ in }
//        return ControlEvent(events: source)
//    }
//    
//    var tapTheme: ControlEvent<Void> {
//        self.base.themeButton.rx.tap
//    }
//    
//    var tapRepository: ControlEvent<Void> {
//        self.base.repositoryButton.rx.tap
//    }
//    
//    var tapFollower: ControlEvent<Void> {
//        self.base.followerButton.rx.tap
//    }
//    
//    var tapFollowing: ControlEvent<Void> {
//        self.base.followingButton.rx.tap
//    }
    
}
// swiftlint:enable type_body_length
