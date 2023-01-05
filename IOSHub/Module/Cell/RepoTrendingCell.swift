//
//  RepoTrendingCell.swift
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
import TTTAttributedLabel
import HiIOS

class RepoTrendingCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let height = 100.f
    }
    
    let usernameSubject = PublishSubject<String>()
    
    lazy var nameLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel.init(frame: .zero)
        label.delegate = self
        label.numberOfLines = 1
        return label
    }()
    
    lazy var langLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    lazy var starsLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(15)
        label.numberOfLines = 2
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.sizeToFit()
        imageView.layerCornerRadius = 4
        imageView.size = IOSHub.Metric.listAvatarSize
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.qmui_borderWidth = pixelOne
        self.contentView.qmui_borderPosition = .bottom
        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.langLabel)
        self.contentView.addSubview(self.starsLabel)
        self.contentView.addSubview(self.descLabel)
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
        self.nameLabel.sizeToFit()
        self.nameLabel.width = self.contentView.width - self.avatarImageView.right - 20
        self.nameLabel.left = self.avatarImageView.right + 10
        self.nameLabel.top = self.avatarImageView.top + 1
        self.langLabel.sizeToFit()
        self.langLabel.width = self.nameLabel.width
        self.langLabel.left = self.nameLabel.left
        self.langLabel.bottom = self.avatarImageView.bottom
        self.starsLabel.sizeToFit()
        self.starsLabel.left = self.contentView.width - 65
        self.starsLabel.centerY = self.langLabel.centerY
        self.descLabel.width = self.contentView.width - 20
        self.descLabel.height = self.contentView.height - self.avatarImageView.bottom - 15
        self.descLabel.left = self.avatarImageView.left
        self.descLabel.top = self.avatarImageView.bottom + 5
    }

    func bind(reactor: RepoTrendingItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.rx.name)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.lang }
            .distinctUntilChanged()
            .bind(to: self.langLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.stars }
            .distinctUntilChanged()
            .bind(to: self.starsLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.desc }
            .distinctUntilChanged()
            .bind(to: self.descLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.avatar }
            .distinctUntilChanged { HiIOS.compareImage($0, $1) }
            .bind(to: self.avatarImageView.rx.imageResource(placeholder: R.image.ic_user_default1()))
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: Metric.height)
    }

}

extension RepoTrendingCell: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith result: NSTextCheckingResult!) {
        guard result.range.location == 0 else { return }
        guard let username = (self.model as? Repo)?.owner.username else { return }
        self.usernameSubject.onNext(username)
    }
}

extension Reactive where Base: RepoTrendingCell {

    var tapUser: ControlEvent<String> {
        let source = self.base.usernameSubject
        return ControlEvent(events: source)
    }
    
    var name: Binder<NSAttributedString?> {
        return Binder(self.base) { cell, name in
            cell.nameLabel.setText(name)
            if let string = name?.string {
                let array = string.components(separatedBy: " / ")
                if array.count == 2 {
                    let length = array.first?.count ?? 0
                    cell.nameLabel.addLink(.init(
                        attributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.primary,
                            NSAttributedString.Key.font: UIFont.bold(16)
                        ],
                        activeAttributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.red
                        ],
                        inactiveAttributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.gray
                        ],
                        textCheckingResult: .spellCheckingResult(range: .init(location: 0, length: length))
                    ))
                }
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }

}
