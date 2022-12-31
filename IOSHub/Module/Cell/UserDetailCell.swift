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
        static let height = 150.f
    }

    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
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
        label.numberOfLines = 2
        label.font = .normal(13)
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 8
        imageView.sizeToFit()
        imageView.size = .init(((Metric.height - StatView.Metric.height) * 0.7).flat)
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
        self.infoView.addSubview(self.nameLabel)
        self.infoView.addSubview(self.joinLabel)
        self.infoView.addSubview(self.introLabel)
        self.infoView.addSubview(self.avatarImageView)
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
        self.avatarImageView.left = 10
        self.avatarImageView.top = self.avatarImageView.topWhenCenter
        self.nameLabel.sizeToFit()
        self.nameLabel.width = self.contentView.width - self.avatarImageView.right - 20
        self.nameLabel.left = self.avatarImageView.right + 10
        self.nameLabel.top = self.avatarImageView.top
        self.joinLabel.sizeToFit()
        self.joinLabel.left = self.nameLabel.left
        self.joinLabel.bottom = self.avatarImageView.bottom
        self.introLabel.sizeToFit()
        self.introLabel.width = self.nameLabel.width
        self.introLabel.left = self.nameLabel.left
        self.introLabel.top = self.nameLabel.bottom
        self.introLabel.extendToBottom = self.joinLabel.top
    }

    func bind(reactor: UserDetailItem) {
        super.bind(item: reactor)
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
        .init(width: width, height: Metric.height)
    }

}
