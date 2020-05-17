//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// 메모 목록에서 사용하는 뷰 모델
/// - 뷰모델은 화면저장과, 메모저장을 전부 처리하는데, 앞에서 구현 한 SceneCoordinator와 MemoStorage를 활용합니다.
/// L5-03 ) 앞에서 구현한 클래스를 상속하겠습니다.
class MemoListViewModel: CommonViewModel {
    // memoList는 메모배열을 방출해야 합니다.
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}
