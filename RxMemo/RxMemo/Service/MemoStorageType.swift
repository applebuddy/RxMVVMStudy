//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation
import RxSwift

// 프로토콜 메서드의 정의 방식)
// 구독자가 옵저바블을 원하는대로 처리할 수 있도록 반환형을 옵저바블로 선언한다. 반대로 작업결과가 필요 없는 경우를 위해 @discardableResult를 선언했다.
// 10-11) 메모를 메모섹션모델로 바꿉니다.
protocol MemoStorageType {
    @discardableResult
    func createMemo(content: String) -> Observable<Memo>

    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]>

    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>

    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
