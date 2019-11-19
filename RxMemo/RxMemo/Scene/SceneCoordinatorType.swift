//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by MinKyeongTae on 2019/11/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation
import RxSwift

// * Completable : Completable을 통해 화면 전환 완료 후 원하는 작업을 구현할 수 있다.
// * @discardableResult : 결과를 사용하지않고 값을 리턴하는 함수 등에는 경고가 발생할 수 있는데 경고를 나타내지 않고자 할 때 사용
protocol SceneCoordinatorType {
    // 새로운 씬을 표시하며, 씬의 애니메이션 플래그, 스타일 등을 전달한다.
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable

    // 현재 씬을 닫고 이전 씬으로 돌아간다.
    @discardableResult
    func close(animated: Bool) -> Completable
}
