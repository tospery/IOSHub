//
//  RepoInfoView.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/11/30.
//

import UIKit
import HiIOS

class RepoInfoView: BaseView {
    
    struct Metric {
//        static let margin = UIEdgeInsets.init(top: 10, left: 10, bottom: 5, right: 10)
//        static let padding = 10.f
//        static let timeHeight = 15.f
//        static let iconSize = CGSize.init(25)
        static let height = 55.f
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.font = .normal(17)
        label.theme.textColor = themeService.attribute { $0.titleColor }
        label.text = "CarGuo/gsy_flutter_demo"
        label.sizeToFit()
        return label
    }()
    
    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
//    lazy var nameLabel: UILabel = {
//        let label = UILabel.init()
//        label.numberOfLines = 2
//        label.font = .normal(17)
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var timeLabel: UILabel = {
//        let label = UILabel.init()
//        label.textAlignment = .right
//        label.font = .normal(13)
//        label.sizeToFit()
//        return label
//    }()
//
//    lazy var descLabel: UILabel = {
//        let label = UILabel.init()
//        label.numberOfLines = SWHub.Metric.summaryMaxLines
//        label.sizeToFit()
//        return label
//    }()
//
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = R.image.ic_repo()
        imageView.sizeToFit()
        imageView.size = .init((Metric.height * 0.7).flat)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.languageLabel)
//        self.addSubview(self.nameLabel)
//        self.addSubview(self.timeLabel)
//        self.addSubview(self.descLabel)
//        themeService.rx
//            .bind({ $0.titleColor }, to: [
//                self.nameLabel.rx.textColor,
//                self.timeLabel.rx.textColor
//            ])
//            .disposed(by: self.rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        .init(width: deviceWidth, height: Metric.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.left = 10
        self.imageView.top = self.imageView.topWhenCenter
        self.nameLabel.sizeToFit()
        self.nameLabel.left = self.imageView.right + 5
        self.nameLabel.bottom = self.imageView.centerY
        self.languageLabel.sizeToFit()
        self.languageLabel.left = self.nameLabel.left
        self.languageLabel.top = self.nameLabel.bottom + 4
//        self.imageView.left = Metric.margin.left
//        self.imageView.top = Metric.margin.top
//        self.nameLabel.sizeToFit()
//        self.nameLabel.height = (self.nameLabel.font.lineHeight * 2).flat
//        self.nameLabel.left = self.imageView.right + Metric.padding
//        self.nameLabel.width = self.width - self.nameLabel.left - Metric.margin.right
//        self.nameLabel.centerY = self.imageView.centerY
//        self.timeLabel.sizeToFit()
//        self.timeLabel.height = Metric.timeHeight
//        self.timeLabel.width = self.width - Metric.margin.left - Metric.margin.right
//        self.timeLabel.right = self.width - Metric.margin.right
//        self.timeLabel.bottom = self.height - Metric.margin.bottom
//        self.descLabel.width = self.timeLabel.width
//        self.descLabel.height = (self.timeLabel.top - self.imageView.bottom - Metric.padding).flat
//        self.descLabel.left = self.imageView.left
//        self.descLabel.top = self.imageView.bottom + Metric.padding / 2.f
    }

}
