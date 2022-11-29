//
//  RepoCell.swift
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

class RepoCell: BaseCollectionCell, ReactorKit.View {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentView.addSubview(self.titleLabel)
//        self.contentView.addSubview(self.imageView)
//        self.contentView.theme.backgroundColor = themeService.attribute { $0.lightColor }
        self.contentView.backgroundColor = .random
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
    }

    func bind(reactor: RepoItem) {
        super.bind(item: reactor)
//        reactor.state.map { _ in }
//            .bind(to: self.rx.setNeedsLayout)
//            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 70)
    }

}
