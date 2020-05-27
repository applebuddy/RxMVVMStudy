//
//  Memo.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation
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
