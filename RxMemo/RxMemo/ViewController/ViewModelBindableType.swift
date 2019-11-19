//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

protocol ViewModelBinableType {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

// 뷰컨트롤러에 추가 된 뷰모델 속성의 실제 뷰모델을 저장, 바인드 뷰모델 메소드를 자동으로 호출하는 메서드를 구현한다.
extension ViewModelBinableType where Self: UIViewController {
    //  바인드 뷰모델 메소드를 자동으로 호출하는 메서드를 구현한다.
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
