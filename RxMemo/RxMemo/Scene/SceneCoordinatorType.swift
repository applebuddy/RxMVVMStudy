//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by MinKyeongTae on 2019/11/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

// MARK: - SceneCoordinatorType

import Foundation
import RxSwift

/// - Scene 처리 타입 정의 프로토콜
protocol SceneCoordinatorType {
    /// - 새로운 Scene 전환 처리
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable

    /// - 현재 Scene을 닫고 이전 Scene 복귀 처리
    @discardableResult
    func close(animated: Bool) -> Completable
}

/*
 // * Completable : Completable을 통해 화면 전환 완료 후 원하는 작업을 구현할 수 있다.
 // * @discardableResult : 결과를 사용하지않고 값을 리턴하는 함수 등에는 경고가 발생할 수 있는데 경고를 나타내지 않고자 할 때 사용한다.
 /// - Scene 코디네이터 타입
 protocol SceneCoordinatorType {
 // 새로운 씬을 표시하며, 씬의 애니메이션 플래그, 스타일 등을 전달한다.
 @discardableResult
 func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable

 // 현재 씬을 닫고 이전 씬으로 돌아가는 메서드 이 메서드는 Completable 반환을 통해 어떤 이벤트가 끝났을때 수행할 수 있도록 할 수 있다.
 @discardableResult
 func close(animated: Bool) -> Completable
 }
 */
