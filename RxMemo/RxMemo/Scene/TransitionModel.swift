//
//  TransitionModel.swift
//  RxMemo
//
//  Created by MinKyeongTae on 2019/11/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

// MARK: - TransitionModel

import Foundation

/// 뷰 전환 스타일 정의 열거형
enum TransitionStyle {
    case root
    case push
    case modal
}

/// 뷰 전환 에러 정의 열거형
enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
