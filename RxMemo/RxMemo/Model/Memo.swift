//
//  Memo.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct Memo: Equatable {
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
