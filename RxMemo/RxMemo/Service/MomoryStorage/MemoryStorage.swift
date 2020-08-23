//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import RxSwift

//  * RxSwift를 사용할때는 reloadData가 아닌 데이터 배열의 갱신을 통해 구현을 할 예정이다.

/// * 메모리에 메모를 저장하는 클래스, MemoStorageType 프로토콜을 준수한다.
/// * 배열을 변경한 다음, Subject에서 새로운 next 이벤트를 방출하는 패턴으로 구현되는 MemoryStorage
// 10-11) MemoryStorage 수정
class MemoryStorage: MemoStorageType {
    // - 배열은 Observable을 통해 외부로 공개됩니다.
    // * 배열이 새롭게 업데이트 되면 새로운 next 이벤트를 방출해야 합니다. 이때 Observable만으로는 부족하다. 이를 위해 Subject를 사용한다.
    // -> 초기값이 존재하는 BehaviorSubject 로 구성한다.

    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)

    // - BehaviorSubject, store를 정의합니다.
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel])

    // * temporary memo data(mock data)
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Lorem Ipsum", insertDate: Date().addingTimeInterval(-20)),
    ]

    // 10-12) 수정
    // - 외부에서는 아래 메서드를 통해 subject에 접근합니다.
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        // 메모 인스턴스를 생성하고,
        let memo = Memo(content: content)

        // 메모의 리스트에 삽입
        sectionModel.items.insert(memo, at: 0)

        // behaviorSubject의 새로운 next이벤트를 방출한다.
        store.onNext([sectionModel])

        // 새로운 메모를 방출하는 Observable을 방출
        return Observable.just(memo)
    }

    // 클래스 외부에서는 항상 memoList() 를 통해 store subject를 접근합니다.
    func memoList() -> Observable<[MemoSectionModel]> {
        return store
    }

    func update(memo: Memo, content: String) -> Observable<Memo> {
        // 1) 업데이트 된 메모 인스턴스를 생성한다.
        let updatedMemo = Memo(original: memo, updatedContent: content)

        // 2) 배열에 저장된 원본 메모 인스턴스 접근해서 업데이트 된, 새로운 인스턴스로 갱신한다.
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updatedMemo, at: index)
        }

        // 3) 새롭게 갱신 한 메모 상태로 BehaviorSubject, store는 새로운 next이벤트(onNext)를 방출한다.
        store.onNext([sectionModel])

        // 4) update 된 메모를 방출하는 Observable을 방출한다.
        return Observable.just(updatedMemo)
    }

    func delete(memo: Memo) -> Observable<Memo> {
        // 1) 인자값으로 받은 memo의 인덱스를 찾아 해당 메모를 삭제한다.
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
            sectionModel.items.remove(at: index)
        }

        // 2) 새롭게 갱신한 메모 상태로 BehaviorSubject, store는 새로운 next 이벤트를 방출한다.
        store.onNext([sectionModel])

        // 3) 삭제된 메모를 방출하는 Observable을 반환한다.
        return Observable.just(memo)
    }
}
