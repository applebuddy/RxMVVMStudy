//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Action
import Foundation
import RxCocoa
import RxSwift

/// Rx-MVVM 패턴을 구현할 때에는 뷰모델을 뷰컨트롤러의 속성으로 추가한다.
/// -> 그 후 뷰 모델과 뷰를 binding 한다.
/// 6-00) - 해당 모델은 ComposeScene에서 메모 편집 등을 할 때 공통적으로 사용합니다.
class MemoComposeViewModel: CommonViewModel {
    private let content: String?

    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }

    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction

    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        self.content = content
        self.saveAction = Action<String, Void> { input in
            // 6-04) 액션이 전달되었다면 실제로 해당 액션을 실행합니다.
            if let action = saveAction {
                action.execute(input)
            }

            // 6-04) 액션이 전달되지 않았다면 그냥 화면만 닫고 끝냅니다.
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }

        // 6-04) cancelAction도 위와 같은 방법으로 래핑하겠습니다.
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute()
            }

            // 09-01) 실제 액션 전달과 관계없이 항상 SceneCoordinator에서 close 메서드를 호출합니다.
            // - 따라서 close메서드는 cancel메서드를 따로 구현할 필요가 없습니다.
            // - 그래서 편집에서는 cancel메서드를 따로 구현할 필요가 없습니다.
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }

        // 6-05) viewModel에서 취소, 저장코드를 직접 구현해도 되지만, 파라미터로 받으면 동적으로 처리방식을 구성할 수 있다는 장점이 있습니다.
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
