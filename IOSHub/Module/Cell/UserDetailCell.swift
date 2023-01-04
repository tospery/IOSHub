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
        static let margin = UIEdgeInsets.init(horizontal: 30, vertical: 20)
        static let padding = UIOffset.init(horizontal: 10, vertical: 5)
    }

    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var joinLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(12)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 0
        label.font = .normal(14)
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 6
        imageView.sizeToFit()
        imageView.size = IOSHub.Metric.detailAvatarSize
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
        self.infoView.addSubview(self.descLabel)
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
        self.avatarImageView.left = Metric.margin.left
        self.avatarImageView.top = Metric.margin.top
        self.nameLabel.sizeToFit()
        self.nameLabel.width = self.contentView.width - self.avatarImageView.right - Metric.padding.horizontal
        self.nameLabel.left = self.avatarImageView.right + Metric.padding.horizontal
        self.nameLabel.top = self.avatarImageView.top
        self.joinLabel.sizeToFit()
        self.joinLabel.left = self.nameLabel.left
        self.joinLabel.bottom = self.avatarImageView.bottom
        self.locationLabel.sizeToFit()
        self.locationLabel.width = self.nameLabel.width
        self.locationLabel.left = self.nameLabel.left
        self.locationLabel.bottom = self.joinLabel.top - 2
        self.descLabel.sizeToFit()
        self.descLabel.width = self.contentView.width - Metric.margin.horizontal
        self.descLabel.left = self.avatarImageView.left
        self.descLabel.top = self.avatarImageView.bottom + Metric.padding.vertical
        self.descLabel.extendToBottom = self.statView.top
    }

    func bind(reactor: UserDetailItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.location }
            .distinctUntilChanged()
            .bind(to: self.locationLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.join }
            .distinctUntilChanged()
            .bind(to: self.joinLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.desc }
            .distinctUntilChanged()
            .bind(to: self.descLabel.rx.text)
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
            attributedString: item.currentState.desc?
                .styled(with: .font(.normal(14))),
            withConstraints: .init(
                width: width - UserDetailCell.Metric.margin.horizontal,
                height: .greatestFiniteMagnitude
            ),
            limitedToNumberOfLines: 0
        ).height
        height += UserDetailCell.Metric.margin.vertical
        height += IOSHub.Metric.detailAvatarSize.height
        height += StatView.Metric.height
        height += UserDetailCell.Metric.padding.vertical * 3
        return .init(width: width, height: height)
    }

}
