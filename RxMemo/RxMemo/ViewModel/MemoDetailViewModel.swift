//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Action
import Foundation
import RxCocoa
import RxSwift

/// 메모보기 화면에서 사용하는 뷰 모델
class MemoDetailViewModel: CommonViewModel {
    // 07-06) 뷰 모델에 사용할 몇가지 속성을 추가하겠습니다.
    let memo: Memo

    // MARK: formatter는 날자를 문자열로 바꿀때 사용합니다.

    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()

    // 07-07) 메모 내용은 테이블 뷰에 표시됩니댜.
    // 왜 기본 옵저버블이 아닌 BehaviorSubject일까요?? 메모보기 이후 편집된 메모를 저장하고 보기화면으로 왔을때의 새로운 문자열 배열을 방출할 수 있도록 할 수 있는 BehaviorSubject를 사용할 수 있습니다. 이어서 생성자를 생성 및 모든 속성을 초기화하겠습니다.
    var contents: BehaviorSubject<[String]>

    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo

        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate),
        ])

        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }

    // 08-06)
    lazy var popAction = CocoaAction { [unowned self] in
        self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
    }
}
