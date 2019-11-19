//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation
import RxSwift

/// 메모리에 메모를 저장하는 클래스, MemoStorageType 프로토콜을 준수한다.
//  * RxSwift를 사용할때는 reloadData가 아닌 데이터 배열의 갱신을 통해 구현을 할 예정이다.
class MemotyStorage: MemoStorageType {
    // * 배열이 새롭게 업데이트 되면 새로운 next 이벤트를 방출해야 한다. 이를 위해 Subject를 만든다.
    // -> 초기값이 존재하는 BehaviorSubject 로 구성한다.

    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Lorem Ipsum", insertDate: Date().addingTimeInterval(-20)),
    ]
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        // 메모 인스턴스를 생성하고,
        let memo = Memo(content: content)
        // 메모의 리스트에 삽입
        list.insert(memo, at: 0)

        // behavoirSubject의 next이벤트를 방출한다.
        store.onNext(list)
        return Observable.just(memo)
    }

    func memoList() -> Observable<[Memo]> {
        return store
    }

    func update(memo: Memo, content: String) -> Observable<Memo> {
        // 업데이트 된 메모 인스턴스를 생성한다.
        let updatedMemo = Memo(original: memo, updatedContent: content)
        // 원본 메모 인스턴스를 업데이트 된 것으로 갱신한다.
        if let index = list.firstIndex(where: { $0 == memo }) {
            // 원본 메모 인덱스를 접근해서 제거 후 제로운 메모로 갱신한다.
            list.remove(at: index)
            list.insert(updatedMemo, at: index)
        }

        // 새롭게 갱신 한 메모 상태로 BehaviorSubject는 새로는 Next이벤트를 방출한다.
        store.onNext(list)
        // 업데이트 된 메모를 방출하는 옵저바블을 방출한다 .
        return Observable.just(updatedMemo)
    }

    func delete(memo: Memo) -> Observable<Memo> {
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
        }

        store.onNext(list)

        return Observable.just(memo)
    }
}
