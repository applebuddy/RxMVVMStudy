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

        // #12_01:26)
        // - 키보드가 나타날 예정일 때마다 새로운 next이벤트를 방출하는 Observable을 리턴합니다.
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }

        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }

        // - 두개의 Observable이 전달되는 시점마다 하나의 Observable에서 next이벤트가 전달됩니다.
        // - 모든 구독자가 Observable을 공유하도록 share()를 추가 설정합니다.
        let keyboardObservable = Observable.merge(willShowObservable, willHideObservable).share()

        // - keyboardObservable의 새로운 구독자를 추가하고, textView의 여백을 조절해보겠습니다.
        keyboardObservable
            .toContentInset(of: contentTextView)
            .bind(to: contentTextView.rx.contentInset)
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

// - CGFloat를 방출하는 ObservableType에 대한 커스텀 extension을 정의합니다.
extension ObservableType where Element == CGFloat {
    func toContentInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var inset = textView.contentInset
            inset.bottom = height
            return inset
        }
    }
}

extension Reactive where Base: UITextView {
    var contentInset: Binder<UIEdgeInsets> {
        return Binder(base) { textView, inset in
            textView.contentInset = inset
        }
    }
}
