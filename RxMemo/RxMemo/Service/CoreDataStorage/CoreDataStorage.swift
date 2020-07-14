//
//  CoreDataStorage.swift
//  RxMemo
//
//  Created by MinKyeongTae on 2020/07/14.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

// MARK: - CoreDataStorage

import CoreData
import Foundation
import RxCoreData
import RxSwift

class CoreDataStorage: MemoStorageType {
    let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // - mainContext 속성을 추가합니다.
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)

        do {
            // - 새로운 메모를 추가할 때는 update 메서드를 사용합니다.
            _ = try mainContext.rx.update(memo)
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
    }

    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]> {
        return mainContext.rx.entities(Memo.self, sortDescriptors: [NSSortDescriptor(key: "insertDate", ascending: false)])
            .map { results in [MemoSectionModel(model: 0, items: results)] }
    }

    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        // - 여기에는 메모 인스턴스와 변경된 내용이 인자로 전달됩니다.
        let updated = Memo(original: memo, updatedContent: content)

        do {
            _ = try mainContext.rx.update(updated)
            return Observable.just(updated)
        } catch {
            return Observable.error(error)
        }
    }

    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        // - 마지막으로 delete 메서드를 구현하겠습니다.
        do {
            try mainContext.rx.delete(memo)
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
    }
}
