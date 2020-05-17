//
//  Scene.swift
//  RxMemo
//
//  Created by MinKyeongTae on 2019/11/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

/// Scene과 관련된 ViewModel을 연관값으로 저장하는 열거형
enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

// 스토리보드에 있는 씬을 생성하고, 연관값에 저장된 뷰모델을 바인딩해서 리턴하는 과정을 정의하는 열거형
extension Scene {
    // main 이름의 스토리 보드로 초기화한 뷰 컨트롤러를 Scene case에 맞는 형태로 반환하는 메서드
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)

        switch self {
        case let .list(viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNavigationController") as? UINavigationController else {
                fatalError()
            }

            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }

            // 뷰 모델을 네비컨트롤러 rootViewController에 binding하고, 리턴할때는 navigationController를 리턴해야 한다.
            // 5-15) 연관 값에 맞는 viewModel을 viewController가 binding 합니다.
            listVC.bind(viewModel: viewModel)
            return nav
        case let .detail(viewModel):
            // detail은 항상 네비게이션 스택에 푸시되므로 네비게이션 컨트롤러를 고려할 필요가 없다.
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            detailVC.bind(viewModel: viewModel)
            return detailVC
        case let .compose(viewModel):
            // 네비게이션 컨트롤러에 Embeded 되어있으므로 이를 고려한다.
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
                fatalError()
            }

            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }

            // 실제 만들어진 씬과 viewModel을 binding하고 해당 뷰컨트롤러를 first로 설정한 네비게이션 컨트롤러(nav)를 리턴한다.
            composeVC.bind(viewModel: viewModel)
            return nav
        }
    }
}
