//
//  UserBasicCell.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/30.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class UserBasicCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 110.f
        static let avatar = 36.f
    }

    lazy var userNameLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var repoNameLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(15)
        label.numberOfLines = 3
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.qmui_borderWidth = pixelOne
        self.contentView.qmui_borderPosition = .bottom
        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.userNameLabel)
        self.contentView.addSubview(self.descLabel)
        self.contentView.addSubview(self.repoNameLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImageView.left = 10
        self.avatarImageView.top = 5
        self.userNameLabel.sizeToFit()
        self.userNameLabel.width = self.contentView.width - 10 - self.avatarImageView.right - 10
        self.userNameLabel.left = self.avatarImageView.right + 10
        self.userNameLabel.top = self.avatarImageView.top - 2
        self.repoNameLabel.sizeToFit()
        self.repoNameLabel.width = self.userNameLabel.width
        self.repoNameLabel.left = self.userNameLabel.left
        self.repoNameLabel.bottom = self.avatarImageView.bottom
        self.descLabel.width = self.contentView.width - 20
        self.descLabel.height = self.contentView.height - self.avatarImageView.bottom - 15
        self.descLabel.left = self.avatarImageView.left
        self.descLabel.top = self.avatarImageView.bottom + 5
    }

    func bind(reactor: UserBasicItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.userName }
            .distinctUntilChanged()
            .bind(to: self.userNameLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.repoName }
            .distinctUntilChanged()
            .bind(to: self.repoNameLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.desc }
            .distinctUntilChanged()
            .bind(to: self.descLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.avatar }
            .distinctUntilChanged { HiIOS.compareImage($0, $1) }
            .bind(to: self.avatarImageView.rx.imageResource(placeholder: R.image.ic_user_default()))
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: Metric.height)
    }

}
