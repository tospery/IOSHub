//
//  EventCell.swift
//  IOSHub
//
//  Created by 杨建祥 on 2023/1/7.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import TTTAttributedLabel
import Rswift
import HiIOS

class EventCell: BaseCollectionCell, ReactorKit.View {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .bold(16)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = .normal(11)
        label.theme.textColor = themeService.attribute { $0.foregroundColor }
        label.sizeToFit()
        return label
    }()
    
    lazy var contentLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel.init(frame: .zero)
        // label.delegate = self
        label.verticalAlignment = .center
        label.numberOfLines = 4
        return label
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.size = .init(55)
        return imageView
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView.init()
        view.sizeToFit()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.bottomView)
        self.bottomView.addSubview(self.iconImageView)
        self.bottomView.addSubview(self.contentLabel)
        self.bottomView.addSubview(self.timeLabel)
        self.contentView.qmui_borderWidth = pixelOne
        self.contentView.qmui_borderPosition = .bottom
        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.sizeToFit()
        self.titleLabel.width = self.contentView.width - 20 * 2
        self.titleLabel.left = 20
        self.titleLabel.top = 8
        self.bottomView.width = self.titleLabel.width
        self.bottomView.left = self.titleLabel.left
        self.bottomView.top = self.titleLabel.bottom
        self.bottomView.extendToBottom = self.contentView.height
        self.iconImageView.left = 0
        self.iconImageView.top = self.iconImageView.topWhenCenter
        self.timeLabel.sizeToFit()
        self.timeLabel.right = self.bottomView.width
        self.timeLabel.bottom = self.bottomView.height - 3
        self.contentLabel.sizeToFit()
        self.contentLabel.width = self.bottomView.width - self.iconImageView.width - 10
        self.contentLabel.left = self.iconImageView.right + 10
        self.contentLabel.top = 0
        self.contentLabel.extendToBottom = self.timeLabel.top
    }

    func bind(reactor: EventItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.time }
            .distinctUntilChanged()
            .bind(to: self.timeLabel.rx.text)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.content }
            .distinctUntilChanged()
            .bind(to: self.contentLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.icon }
            .distinctUntilChanged { HiIOS.compareImage($0, $1) }
            .bind(to: self.iconImageView.rx.imageResource(placeholder: R.image.ic_user_default1()))
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 115)
    }

}
