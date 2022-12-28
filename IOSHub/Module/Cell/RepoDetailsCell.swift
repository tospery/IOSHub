//
//  RepoDetailsCell.swift
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
import HiIOS

class RepoDetailsCell: BaseCollectionCell, ReactorKit.View {
    
    struct Metric {
        static let maxLines = 5
        static let padding = 10.f
        static let margin = 10.f
    }
    
    lazy var infoView: RepoInfoView = {
        let view = RepoInfoView.init()
        view.sizeToFit()
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = Metric.maxLines
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentView.qmui_borderWidth = pixelOne
//        self.contentView.qmui_borderPosition = .bottom
//        self.contentView.qmui_borderInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
//        self.contentView.theme.qmui_borderColor = themeService.attribute { $0.borderColor }
//        self.contentView.addSubview(self.infoView)
//        self.contentView.addSubview(self.descLabel)
        self.contentView.backgroundColor = .orange
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.infoView.setNeedsLayout()
        self.infoView.layoutIfNeeded()
        self.infoView.left = 0
        self.infoView.top = 0
        self.descLabel.width = self.contentView.width - Metric.margin * 2
        self.descLabel.height = self.contentView.height - RepoInfoView.Metric.height - Metric.margin
        self.descLabel.left = Metric.margin
        self.descLabel.top = self.infoView.bottom
    }

    func bind(reactor: RepoDetailsItem) {
        super.bind(item: reactor)
        reactor.state.map { $0.repo }
            .distinctUntilChanged()
            .bind(to: self.infoView.rx.repo)
            .disposed(by: self.disposeBag)
        reactor.state.map { $0.desc }
            .distinctUntilChanged()
            .bind(to: self.descLabel.rx.attributedText)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 190)
//        guard let item = item as? RepoDetailsItem else { return .zero }
//        var height = RepoInfoView.Metric.height
//        height += UILabel.size(
//            attributedString: item.currentState.desc,
//            withConstraints: .init(
//                width: width - Metric.margin * 2,
//                height: .greatestFiniteMagnitude
//            ),
//            limitedToNumberOfLines: UInt(Metric.maxLines)
//        ).height
//        height += Metric.margin
//        return .init(width: width, height: height)
    }

}
