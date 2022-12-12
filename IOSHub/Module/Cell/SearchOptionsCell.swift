//
//  SearchOptionsCell.swift
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

class SearchOptionsCell: BaseCollectionCell, ReactorKit.View {
 
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl.init(items: [
            R.string.localizable.repositores(),
            R.string.localizable.users()
        ])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setWidth(120, forSegmentAt: 0)
        segmentedControl.setWidth(120, forSegmentAt: 1)
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
        self.segmentedControl.left = self.segmentedControl.leftWhenCenter
        self.segmentedControl.top = self.segmentedControl.topWhenCenter
    }

    func bind(reactor: SearchOptionsItem) {
        super.bind(item: reactor)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 70)
    }

}
