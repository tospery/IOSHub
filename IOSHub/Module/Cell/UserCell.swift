//
//  UserCell.swift
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

class UserCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 75.f
        static let maxLines = 2
    }

    lazy var fullnameLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        label.height = UIFont.normal(17).lineHeight
        return label
    }()
    
    lazy var repoNameLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        label.height = UIFont.normal(14).lineHeight
        return label
    }()
    
    lazy var repoDescLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(12)
        label.numberOfLines = 1
        label.theme.textColor = themeService.attribute { $0.bodyColor }
        label.sizeToFit()
        label.height = label.font.lineHeight
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 6
        imageView.sizeToFit()
        imageView.size = .init((Metric.height * 0.75).flat)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.qmui_borderWidth = pixelOne
        self.contentView.qmui_borderPosition = .bottom
        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.fullnameLabel)
        self.contentView.addSubview(self.repoDescLabel)
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
        self.avatarImageView.top = self.avatarImageView.topWhenCenter
        self.fullnameLabel.width = self.contentView.width - 10 - self.avatarImageView.right - 10
        self.fullnameLabel.left = self.avatarImageView.right + 10
        self.fullnameLabel.top = self.avatarImageView.top - 4
        self.repoNameLabel.width = self.fullnameLabel.width
        self.repoNameLabel.left = self.fullnameLabel.left
        self.repoNameLabel.top = self.fullnameLabel.bottom + 3
        self.repoDescLabel.width = self.fullnameLabel.width
        self.repoDescLabel.left = self.fullnameLabel.left
        self.repoDescLabel.top = self.repoNameLabel.bottom + 3
    }

    func bind(reactor: UserItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.fullname }
            .distinctUntilChanged()
            .bind(to: self.fullnameLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.repoName }
            .distinctUntilChanged()
            .bind(to: self.repoNameLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.repoDesc }
            .distinctUntilChanged()
            .bind(to: self.repoDescLabel.rx.text)
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
