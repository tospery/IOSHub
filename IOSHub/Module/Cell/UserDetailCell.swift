//
//  UserDetailCell.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/31.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class UserDetailCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 130.f
        static let avatar = 40.f
    }

    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(13)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var joinLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(11)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var introLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 0
        label.font = .normal(14)
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 4
        imageView.sizeToFit()
        imageView.size = .init(Metric.avatar)
        return imageView
    }()
    
    lazy var infoView: UIView = {
        let view = UIView.init()
        view.sizeToFit()
        return view
    }()
    
    lazy var statView: StatView = {
        let view = StatView.init()
        view.sizeToFit()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.statView)
        self.contentView.addSubview(self.infoView)
        self.infoView.addSubview(self.avatarImageView)
        self.infoView.addSubview(self.nameLabel)
        self.infoView.addSubview(self.locationLabel)
        self.infoView.addSubview(self.joinLabel)
        self.infoView.addSubview(self.introLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.statView.left = 0
        self.statView.bottom = self.contentView.height
        self.infoView.width = self.contentView.width
        self.infoView.height = self.statView.top
        self.infoView.left = 0
        self.infoView.top = 0
        self.avatarImageView.left = 15
        self.avatarImageView.top = 10
        self.nameLabel.sizeToFit()
        self.nameLabel.width = self.contentView.width - self.avatarImageView.right - 25
        self.nameLabel.left = self.avatarImageView.right + 10
        self.nameLabel.top = self.avatarImageView.top
        self.locationLabel.sizeToFit()
        self.locationLabel.width = self.nameLabel.width
        self.locationLabel.left = self.nameLabel.left
        self.locationLabel.bottom = self.avatarImageView.bottom
        self.joinLabel.sizeToFit()
        self.joinLabel.right = self.nameLabel.right
        self.joinLabel.bottom = self.infoView.height - 4
        self.introLabel.sizeToFit()
        self.introLabel.width = self.contentView.width - 30
        self.introLabel.left = self.avatarImageView.left
        self.introLabel.top = self.avatarImageView.bottom + 8
        self.introLabel.extendToBottom = self.joinLabel.top
    }

    func bind(reactor: UserDetailItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.location }
            .distinctUntilChanged()
            .bind(to: self.locationLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.join }
            .distinctUntilChanged()
            .bind(to: self.joinLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.intro }
            .distinctUntilChanged()
            .bind(to: self.introLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.nameLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.avatar }
            .distinctUntilChanged { HiIOS.compareImage($0, $1) }
            .bind(to: self.avatarImageView.rx.imageResource(placeholder: R.image.ic_user_default()))
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .bind(to: self.statView.rx.user)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        guard let item = item as? UserDetailItem else { return .zero }
        var height = UILabel.size(
            attributedString: item.currentState.intro?
                .styled(with: .font(.normal(14))),
            withConstraints: .init(
                width: width - 30,
                height: .greatestFiniteMagnitude
            ),
            limitedToNumberOfLines: 0
        ).height
        height += 10
        height += UserDetailCell.Metric.avatar
        height += StatView.Metric.height
        height += 30
        return .init(width: width, height: height)
    }

}
