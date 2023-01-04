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
        static let margin = UIEdgeInsets.init(horizontal: 30, vertical: 20)
        static let padding = UIOffset.init(horizontal: 10, vertical: 5)
    }
    
    lazy var nameLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel.init(frame: .zero)
        label.delegate = self
        label.numberOfLines = 1
        return label
    }()
    
    lazy var langLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    
    lazy var updateLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(12)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = Metric.maxLines
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
    
    lazy var statView: StatView = {
        let view = StatView.init()
        view.sizeToFit()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.statView)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.updateLabel)
        self.contentView.addSubview(self.langLabel)
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
        self.statView.left = 0
        self.statView.bottom = self.contentView.height
        self.avatarImageView.left = Metric.margin.left
        self.avatarImageView.top = Metric.margin.top
        self.nameLabel.sizeToFit()
        self.nameLabel.width = self.contentView.width - self.avatarImageView.right - Metric.padding.horizontal
        self.nameLabel.left = self.avatarImageView.right + Metric.padding.horizontal
        self.nameLabel.top = self.avatarImageView.top
        self.updateLabel.sizeToFit()
        self.updateLabel.left = self.nameLabel.left
        self.updateLabel.bottom = self.avatarImageView.bottom
        self.langLabel.sizeToFit()
        self.langLabel.width = self.nameLabel.width
        self.langLabel.left = self.nameLabel.left
        self.langLabel.bottom = self.updateLabel.top - 2
        self.descLabel.sizeToFit()
        self.descLabel.width = self.contentView.width - Metric.margin.horizontal
        self.descLabel.left = self.avatarImageView.left
        self.descLabel.top = self.avatarImageView.bottom + Metric.padding.vertical
        self.descLabel.extendToBottom = self.statView.top
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
        reactor.state.map { $0.lang }
            .distinctUntilChanged()
            .bind(to: self.langLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.update }
            .distinctUntilChanged()
            .bind(to: self.updateLabel.rx.text)
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
        guard let item = item as? RepoDetailItem else { return .zero }
        var height = StatView.Metric.height
        height += UILabel.size(
            attributedString: item.currentState.desc?.styled(with: .font(.normal(14))),
            withConstraints: .init(
                width: width - Metric.margin.horizontal,
                height: .greatestFiniteMagnitude
            ),
            limitedToNumberOfLines: UInt(Metric.maxLines)
        ).height
        height += (Metric.margin.vertical * 2)
        height += IOSHub.Metric.detailAvatarSize.height
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
