//
//  SearchTypeCell.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/12.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import HiIOS

class SearchTypeCell: BaseCollectionCell, ReactorKit.View {
    
//    lazy var titleLabel: UILabel = {
//        let label = UILabel.init(frame: .zero)
//        label.font = .normal(15)
//        label.text = "v\(UIApplication.shared.version!)(\(UIApplication.shared.buildNumber!))"
//        label.theme.textColor = themeService.attribute { $0.bodyColor }
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = R.image.appLogo()
//        imageView.sizeToFit()
//        imageView.size = .init(deviceWidth * 0.24)
//        return imageView
//    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl.init(items: [
            R.string.localizable.repositores(),
            R.string.localizable.users()
        ])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.normal(15),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .selected)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.normal(15),
            NSAttributedString.Key.foregroundColor: UIColor.title
        ], for: .normal)
        segmentedControl.sizeToFit()
        return segmentedControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentView.addSubview(self.titleLabel)
//        self.contentView.addSubview(self.imageView)
//        self.contentView.theme.backgroundColor = themeService.attribute { $0.lightColor }
        self.contentView.addSubview(self.segmentedControl)
        // self.contentView.backgroundColor = .orange
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        self.imageView.left = self.imageView.leftWhenCenter
//        self.imageView.top = (self.imageView.topWhenCenter * 0.9).flat
//        self.titleLabel.left = self.titleLabel.leftWhenCenter
//        self.titleLabel.top = self.imageView.bottom + 5
        self.segmentedControl.left = self.segmentedControl.leftWhenCenter
        self.segmentedControl.top = self.segmentedControl.topWhenCenter
    }

    func bind(reactor: SearchTypeItem) {
        super.bind(item: reactor)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 90)
    }

}
