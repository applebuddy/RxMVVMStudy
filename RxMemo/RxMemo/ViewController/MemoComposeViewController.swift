//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Action
import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

class MemoComposeViewController: UIViewController, ViewModelBinableType {
    // MARK: - IB

    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var contentTextView: UITextView!

    // MARK: - Property

    var viewModel: MemoComposeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {
        // 6-9) 먼저, navigation title 을 바인딩하겠습니다.
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)

        // 6-9) 이어서 initialText를 textView에 바인딩하겠습니다.
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)

        // 6-10) 취소버튼은 cancelAction과 바인딩하겠습니다.
        // action 패턴으로 action 구현시는 아래와 같이 action에 저장하는 방식으로 처리할 수 있습니다.
        cancelButton.rx.action = viewModel.cancelAction

        // 6-10) 저장버튼도 구현합니다. boubleTap을 막기위해서 throttle연산자를 활용합니다.
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty) // withLatestFrom 연산자로 텍스트뷰의 텍스트를 방출할 수 있습니다.
            .bind(to: viewModel.saveAction.inputs) // 이어서 방출된 텍스트를 saveAction과 바인딩 하겠습니다.
            .disposed(by: rx.disposeBag)
    }

    // 6-08) viewWillAppear가 호출될 때 contentTextView를 firstResponder로 설정하겠습니다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.becomeFirstResponder()
    }

    // 6-09) viewWillDisappear 호출시에는 firstResponder를 헤제하겠습니다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
