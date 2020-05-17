//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

// MARK: - RxMemo

// MARK: RxMemo 프로젝트는 MVVM 패턴으로 구현 됩니다.

// * RM-1 : Main.storyboard, LaunchScreen.storyboard는 ViewController Group Folder로 옮겨 놓습니다.

import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

/// RxSwift에서는 RxCocoa이 추가한 Tap 속성을 구독하거나, Action 속성에 Action을 직접 할당하는 방식으로 진행합니다.
class MemoListViewController: UIViewController, ViewModelBinableType {
    // MARK: - IB

    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var listTableView: UITableView!

    // MARK: - Properties

    var viewModel: MemoListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 5-07) bindViewModel 메서드에서 ViewModel과 View를 바인딩 하겠습니다.
    func bindViewModel() {
        // 5-08) 아래와 같이 설정하면 viewModel에 표시된 title이 navigationBarButtonItem에 표시 됩니다.
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)

        // 5-08) 이제 메모목록을 테이블뷰에 바인딩하면 끝납니다.
        // 5-16) 아래에서 메모정보를 방출하는 Observable과 tableView를 바인딩합니다. 지금까지의 구현 방식으로 테이블뷰가 처리됩니다.
        // ★ 처음에는 이와 같은 내용이 와닿지 않을 수 있습니다. 이를 위해 다양한 MVVM패턴을 구현해볼 필요가 있습니다. 관련해서는 RxMemo앱을 만들어 본 뒤, 조금더 구체적으로 Rx에 대해 공부해야 합니다.
        // * 도움이 될만한 링크는 강의자료에 첨부하겠습니다. ▼
        // [웹사이트] Clean Architecture and MVVM on iOS
        // - https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3
        // [웹사이트] Advanced iOS App Architecture
        // - https://store.raywenderlich.com/products/advanced-ios-app-architecture
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { _, memo, cell in
                // 5-09) closure 내에서 cell 구성코드를 작성합니다.
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)

        // 06-18) 마지막으로 목록화면으로 가서 + 버튼과 액션을 바인딩 합니다. add 버튼이죠. 이후 메모를 저장하면 저장된 메모가 추가됩니다. E.
        addButton.rx.action = viewModel.makeCreateAction()
    }
}
