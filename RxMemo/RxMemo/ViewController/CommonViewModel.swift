//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by MinKyeongTae on 2020/05/17.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CommonViewModel: NSObject {
    let title: Driver<String>

    // 프로토콜을 활용하면 의존성을 쉽게 수정할 수 있습니다.
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType

    // 속성을 초기화하는 생성자를 추가하겠습니다.
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
