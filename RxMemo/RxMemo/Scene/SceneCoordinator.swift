//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by MinKyeongTae on 2019/11/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

// MARK: - SceneCoordinator

import Foundation
import RxCocoa
import RxSwift

/// * 화면 전환을 담당하는 SceneCoordinator
class SceneCoordinator: SceneCoordinatorType {
    private let disposeBag = DisposeBag()
    private var window: UIWindow
    private var currentVC: UIViewController

    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }

    /// 전환 상태에 따라서 실제 전환처리를 수행하는 메서드, transition
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        let target = scene.instantiate()
        switch style {
        case .root:
            currentVC = target
            window.rootViewController = target
            subject.onCompleted()
        case .push:
            // 네비게이션 컨트롤러 embeded 상태를 확인 후 처리, 만약 embeded 상태가 아니라면 error 이벤트를 전달하고 중지한다.
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            // 만약 네비게이션 컨틀롤러가 정상적으로 embeded되어 있다면 pushViewController를 수행하고, completed 이벤트를 전달한다.
            nav.pushViewController(target, animated: animated)
            currentVC = target
            subject.onCompleted()
        case .modal:
            currentVC.present(target, animated: animated) {
                // present의 completionHandler를 통해 onCompleted() 이벤트를 전달
                subject.onCompleted()
            }
            currentVC = target
        }

        // * ignoreElements() : Completable 로 변환되어 반환된다.
        // 초반에 정의할 수도 있지만 그렇게 하면 처리하기 위해 구현하는 코드가 복잡해 지므로 해당 라인에서 ingoreElements를 사용하여 반환한다.
        return subject.ignoreElements()
    }

    /// 뷰컨트롤러를 닫는 메서드
    @discardableResult
    func close(animated: Bool) -> Completable {
        // ignoreElements() 사용 유무에 따른 차이를 위해 close메서드에서는 Completable을 사전에 지정하고 사용해본다.
        return Completable.create { [unowned self] completable in
            // 현재 띄워진 뷰 컨트롤러를 확인 후(presentingViewController == nil ? )
            if let presentingVC = self.currentVC.presentingViewController {
                // dismiss 가능하면 dismiss 처리한다.
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
                // 현재 viewController의 navigationController 가 존재한다면,
            } else if let nav = self.currentVC.navigationController {
                // 네이게이션 컨트롤러 스택에 뷰컨트롤러가 있다면 popViewController 메서드를 통해 pop 처리합니다.
                guard nav.popViewController(animated: animated) != nil else {
                    // pop이 불가능하다면, error 이벤트를 실행합니다.
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                // 만약 팝이 더이상 안될 경우 에러 이벤트를 실행한다.
                completable(.error(TransitionError.unknown))
            }
            return Disposables.create()
        }
    }
}
