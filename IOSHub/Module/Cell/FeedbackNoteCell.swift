//
//  FeedbackNoteCell.swift
//  IOSHub
//
//  Created by 杨建祥 on 2023/1/6.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import TTTAttributedLabel
import BonMot
import HiIOS

class FeedbackNoteCell: BaseCollectionCell, ReactorKit.View {
    
    let issuesSubject = PublishSubject<Void>()
    
    lazy var label: TTTAttributedLabel = {
        let label = TTTAttributedLabel.init(frame: .zero)
        label.delegate = self
        label.numberOfLines = 0
        label.textAlignment = .right
        label.verticalAlignment = .center
        let tips = R.string.localizable.feedbackNote()
        let author = "\(Author.username)/\(Author.reponame)"
        let text = NSAttributedString.composed(of: [
            tips.styled(with: .font(.normal(14)), .color(.title)),
            Special.nextLine,
            author.styled(with: .font(.bold(15)), .color(.primary))
        ])
        label.setText(text)
        let range = text.string.range(of: author)!
        let link = TTTAttributedLabelLink.init(
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.primary,
                NSAttributedString.Key.font: UIFont.bold(15)
            ],
            activeAttributes: [
                NSAttributedString.Key.foregroundColor: UIColor.red
            ],
            inactiveAttributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ],
            textCheckingResult:
                .spellCheckingResult(
                    range: .init(
                        location: text.string.nsRange(from: range).location,
                        length: author.count)
                )
        )
        label.addLink(link)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.label)
        self.contentView.theme.backgroundColor = themeService.attribute { $0.lightColor }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.sizeToFit()
        self.label.width = self.contentView.width - 20 * 2
        self.label.height = self.contentView.height
        self.label.left = self.label.leftWhenCenter
        self.label.top = self.label.topWhenCenter
    }

    func bind(reactor: FeedbackNoteItem) {
        super.bind(item: reactor)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
        .init(width: width, height: 50)
    }

}

extension FeedbackNoteCell: TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith result: NSTextCheckingResult!) {
        self.issuesSubject.onNext(())
    }

}

extension Reactive where Base: FeedbackNoteCell {
    
    var issues: ControlEvent<Void> {
        let source = self.base.issuesSubject.map { _ in }
        return ControlEvent(events: source)
    }
    
}
