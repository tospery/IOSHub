//
//  HistoryKeywordsCell.swift
//  IOSHub
//
//  Created by 杨建祥 on 2022/12/17.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import URLNavigator
import Rswift
import TagListView
import HiIOS

class HistoryKeywordsCell: BaseCollectionCell, ReactorKit.View {
    
    let tagSubject = PublishSubject<String>()
    
    // tagListView
    lazy var tagView: TagListView = {
        let view = TagListView.init(frame: .zero)
        view.paddingX = 20
        view.paddingY = 8
        view.marginX = 10
        view.marginY = 10
        view.textFont = .normal(14)
        view.textColor = .title
        view.tagBackgroundColor = .light
        view.cornerRadius = 15
        view.delegate = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.tagView)
        self.contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.tagView.width = self.contentView.width - 20 * 2
        self.tagView.height = self.contentView.height - 15
        self.tagView.left = self.tagView.leftWhenCenter
        self.tagView.top = 0
    }

    func bind(reactor: HistoryKeywordsItem) {
        super.bind(item: reactor)
        if let parent = reactor.parent as? NormalViewReactor {
            parent.state.map { $0.keywords }
                .distinctUntilChanged()
                .map { Reactor.Action.keywords($0) }
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        }
        reactor.state.map { $0.keywords }
            .distinctUntilChanged()
            .bind(to: self.rx.keywords)
            .disposed(by: self.disposeBag)
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
    }
    
    override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
//        guard let id = (item as? SearchKeywordItem)?.currentState.id else { return .zero }
//        return .init(width: width, height: id == R.string.localizable.searchHistory() ? 40 : 120)
        .init(width: width, height: 76)
    }

}

extension HistoryKeywordsCell: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.tagSubject.onNext(title)
    }
}

extension Reactive where Base: HistoryKeywordsCell {
    var select: ControlEvent<String> {
        ControlEvent(events: self.base.tagSubject)
    }
    
    var keywords: Binder<[String]> {
        return Binder(self.base) { cell, keywords in
            cell.tagView.removeAllTags()
            cell.tagView.addTags(keywords)
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
    }
}
