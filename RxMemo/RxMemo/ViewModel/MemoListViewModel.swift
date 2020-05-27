//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Action
import Foundation
import RxCocoa
import RxDataSources // 10) ~
import RxSwift

typealias MemoSectionModel = AnimatableSectionModel<Int, Memo>

/// 메모 목록에서 사용하는 뷰 모델
/// - 뷰모델은 화면저장과, 메모저장을 전부 처리하는데, 앞에서 구현 한 SceneCoordinator와 MemoStorage를 활용합니다.
/// L5-03 ) 앞에서 구현한 클래스를 상속하겠습니다.
class MemoListViewModel: CommonViewModel {
    let dataSource: RxTableViewSectionedAnimatedDataSource<MemoSectionModel> = {
        let ds =
            RxTableViewSectionedAnimatedDataSource<MemoSectionModel>(configureCell: { (_, tableView, indexPath, memo) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = memo.content
                return cell
            })

        ds.canEditRowAtIndexPath = { _, _ in true }
        return ds
    }()

    // memoList는 메모배열을 방출해야 합니다.
    var memoList: Observable<[MemoSectionModel]> {
        return storage.memoList()
    }

    // 09-00) MemoListViewModel을 보면, performUpdate, performCancel 메서드에서 쓰기에서 실행할 액션을 구현하고,
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input).map { _ in } // .map { _ in } 을 추가하면 Observable<Void> 형으로 반환할 수 있습니다.
        }
    }

    // 06_16) 이어서 cancelAction을 리턴하는 메서드를 구현하겠습니다.
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            // 여기서는 생성된 메모를 삭제하겠습니다. createMemo를 호출하면 메모가 생성되는데, 이를 삭제하지 않으면 불필요한 메모가 저장될 수 있습니다. createMemo를 통해 내용 없는 메모를 생성, 저장이 되면 입력된 메모로 업데이트하는 방식입니다.
            self.storage.delete(memo: memo).map { _ in }
        }
    }

    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            // 6-13) 이렇게 createMemo를 호출하면 새로운 메모가 생성되고, 이 메모를 방촐하는 옵저버블이 반환됩니다.
            self.storage.createMemo(content: "") // 이어서 flatMap 연산자를 호출하고 클로저에서 화면전환을 처리합니다.
                .flatMap { memo -> Observable<Void> in
                    // 09-00) CocoaAction의 composeViewModel에서 memo가 생성될때 인자값으로 넘기고 있습니다.
                    // 여기에서는 먼저 뷰 모델을 만들어야 합니다.
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))

                    // 이어서 composeScene을 생성하고 연관값으로 viewModel을 저장하겠습니다.
                    let composeScene = Scene.compose(composeViewModel)
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }
                }
        }
    }

    // 07-12) 클로져 내부에서 self에 접근해야 하기 때문에 lazy var로 선언해서 사용합니다.
    lazy var detailAction: Action<Memo, Void> = {
        Action { memo in

            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)

            let detailScene = Scene.detail(detailViewModel)

            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().map { _ in }
            // 07-14) 이후 MemoListViewController 로 가서 방금 구현한 Action을 binding 하겠습니다.
        }
    }()

    // 10-2) 여기에서 앞서 했던 detailAction과 동일한 방식으로 deleteAction 액션을 구현해보겠습니다.
    lazy var deleteAction: Action<Memo, Swift.Never> = {
        Action { memo in
            // 여기서는 메모를 삭제만 하면 됩니다. 이전 뷰로 돌아갈 필요는 없습니다.
            self.storage.delete(memo: memo).ignoreElements()
        }
    }()

    // 10-3) 이번에는 listViewController로 가보겠습니다.
}
