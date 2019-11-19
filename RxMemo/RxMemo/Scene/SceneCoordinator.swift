//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by MinKyeongTae on 2019/11/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// 화면 전환을 담당한다.
class SceneCoordinator: SceneCoordinatorType {
    private let disposeBag = DisposeBag()
    private var window: UIWindow
    private var currentVC: UIViewController

    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }

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
            // 네비게이션 컨트롤러 embeded 상태를 확인 후 처리
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
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
        return subject.ignoreElements()
    }

    @discardableResult
    func close(animated: Bool) -> Completable {
        // ignoreElements() 사용 유무에 따른 차이를 위해 close메서드에서는 Completable을 사전에 지정하고 사용해본다.
        return Completable.create { [unowned self] completable in
            // 현재 띄워진 뷰 컨트롤러를 확인 후 팝하는데 팝이 더이상 안될 경우 에러이벤트를 실행한다.
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }
            return Disposables.create()
        }
    }
}
