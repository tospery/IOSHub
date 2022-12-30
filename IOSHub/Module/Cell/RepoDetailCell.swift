//
//  RepoDetailCell.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import TTTAttributedLabel
import HiIOS

class RepoDetailCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let maxLines = 5
        static let padding = 10.f
        static let margin = 15.f
        static let avatar = 28.f
    }
    
    lazy var nameLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel.init(frame: .zero)
        label.delegate = self
        label.numberOfLines = 1
        return label
    }()
    
    lazy var updateLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(11)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
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
        let imageView = UIImageView()
        imageView.layerCornerRadius = 4
        imageView.sizeToFit()
        imageView.size = .init(Metric.avatar)
        return imageView
    }()
    
    lazy var statView: RepoStatView = {
        let view = RepoStatView.init()
        view.sizeToFit()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.descLabel)
        self.contentView.addSubview(self.updateLabel)
        self.contentView.addSubview(self.statView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        self.infoView.setNeedsLayout()
//        self.infoView.layoutIfNeeded()
//        self.infoView.left = 0
//        self.infoView.top = 0
        self.statView.left = 0
        self.statView.bottom = self.contentView.height
        self.avatarImageView.left = Metric.margin
        self.avatarImageView.top = 5
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.avatarImageView.right + 10
        self.nameLabel.width = self.contentView.width - self.nameLabel.left - Metric.margin
        self.nameLabel.centerY = self.avatarImageView.centerY
        self.updateLabel.sizeToFit()
        self.updateLabel.right = self.contentView.width - Metric.margin
        self.updateLabel.bottom = self.statView.top - 5
        self.descLabel.sizeToFit()
        self.descLabel.width = self.contentView.width - Metric.margin * 2
        self.descLabel.left = Metric.margin
        self.descLabel.top = self.avatarImageView.bottom + 5
        self.descLabel.extendToBottom = self.updateLabel.top
    }

    func bind(reactor: RepoDetailItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.repo }
            .distinctUntilChanged()
            .bind(to: self.statView.rx.repo)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: self.rx.name)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.updateAgo }
            .distinctUntilChanged()
            .bind(to: self.updateLabel.rx.text)
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
        // .init(width: width, height: 190)
        guard let item = item as? RepoDetailItem else { return .zero }
        var height = RepoStatView.Metric.height
        height += UILabel.size(
            attributedString: item.currentState.desc,
            withConstraints: .init(
                width: width - Metric.margin * 2,
                height: .greatestFiniteMagnitude
            ),
            limitedToNumberOfLines: UInt(Metric.maxLines)
        ).height
        height += (Metric.margin * 2)
        height += Metric.avatar
        return .init(width: width, height: height)
    }

}

extension RepoDetailCell: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith result: NSTextCheckingResult!) {
        // self.termBlock?(result.range.location)
        log("点击位置->\(result.range.location)")
    }
}

extension Reactive where Base: RepoDetailCell {

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
