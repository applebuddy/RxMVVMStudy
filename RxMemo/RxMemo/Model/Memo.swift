//
//  Memo.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxDataSources

// 10-6) IdentifiableType에는 identiry 프로퍼티가 선언되어 있습니다. Hashable 프로토콜을 채용한 상태로 제한되어 있습니다. String은 Hashable 프로토콜을 충족하므로 그대로 두어도 됩니다.
struct Memo: Equatable, IdentifiableType {
    var content: String
    var insertDate: Date
    var identity: String // 메모 구분에 사용하는 프로퍼티

    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate

        // insertDate의 2001/1/1 UTC 시간 기준, TimeInterval 값을 identity에 넣음
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }

    init(original: Memo, updatedContent: String) {
        self = original
        content = updatedContent
    }
}

// - #21-08:00) Persistable 프로토콜을 채택하여 구현합니다.
extension Memo: Persistable {
    public static var entityName: String {
        return "Memo"
    }

    static var primaryAttributeName: String {
        return "identity"
    }

    init(entity: NSManagedObject) {
        content = entity.value(forKey: "content") as! String
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }

    func update(_ entity: NSManagedObject) {
        entity.setValue(content, forKey: "content")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")

        // - save 메서드를 직접 호출해주어야 합니다. 그렇지 않으면 update한 내용이 사라질 수도 있습니다.
        //   -> 그러므로 Rx로 CoreData를 구현할때는 이부분을 조심해줘야 합니다.
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
}
