//
//  RepoBasicCell.swift
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
import HiIOS

class RepoBasicCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let padding = 10.f
        static let margin = 10.f
        static let avatar = 36.f
        static let maxLines = 5
    }
    
    lazy var fullnameLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    lazy var starsnumLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = Metric.maxLines
        label.sizeToFit()
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.sizeToFit()
        imageView.layerCornerRadius = 4
        imageView.size = .init(Metric.avatar)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.qmui_borderWidth = pixelOne
        self.contentView.qmui_borderPosition = .bottom
        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.contentView.addSubview(self.fullnameLabel)
        self.contentView.addSubview(self.languageLabel)
        self.contentView.addSubview(self.starsnumLabel)
        self.contentView.addSubview(self.descLabel)
        self.contentView.addSubview(self.avatarImageView)
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
        self.fullnameLabel.sizeToFit()
        self.fullnameLabel.width = self.contentView.width - self.avatarImageView.right - 20
        self.fullnameLabel.left = self.avatarImageView.right + 10
        self.fullnameLabel.top = self.avatarImageView.top - 2
        self.languageLabel.sizeToFit()
        self.languageLabel.left = self.fullnameLabel.left
        self.languageLabel.bottom = self.avatarImageView.bottom
        self.starsnumLabel.sizeToFit()
        self.starsnumLabel.right = self.contentView.width - 10
        self.starsnumLabel.centerY = self.languageLabel.centerY
        self.descLabel.sizeToFit()
        self.descLabel.width = self.contentView.width - 20
        self.descLabel.height = self.contentView.height - self.avatarImageView.bottom - 15
        self.descLabel.left = 10
        self.descLabel.top = self.avatarImageView.bottom + 5
    }

    func bind(reactor: RepoBasicItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.fullname }
            .distinctUntilChanged()
            .bind(to: self.fullnameLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.language }
            .distinctUntilChanged()
            .bind(to: self.languageLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.starsnum }
            .distinctUntilChanged()
            .bind(to: self.starsnumLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.desc }
            .distinctUntilChanged()
            .bind(to: self.descLabel.rx.attributedText)
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
        guard let item = item as? RepoBasicItem else { return .zero }
        var height = UILabel.size(
            attributedString: item.currentState.desc,
            withConstraints: .init(
                width: width - Metric.margin * 2,
                height: .greatestFiniteMagnitude
            ),
            limitedToNumberOfLines: UInt(Metric.maxLines)
        ).height + 5.f
        height += Metric.margin
        height += Metric.avatar
        return .init(width: width, height: height)
    }

}
