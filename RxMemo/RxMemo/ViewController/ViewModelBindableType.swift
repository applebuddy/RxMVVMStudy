//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

// - ViewController에 추가 된 뷰모델 속성의 실제 ViewModel을 저장 후 bind() 뷰모델 메서드를 자동으로 호출하는 메서드를 구현한다.
//   - 아래와 같이 하면 개별적인 ViewController에서 일일히 bindViewModel메서드를 호출할 필요가 없어져 코드가 보다 간결해 집니다.
extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()

        bindViewModel()
    }
}

/*
 protocol ViewModelBindableType {
 associatedtype ViewModelType

 var viewModel: ViewModelType! { get set }
 func bindViewModel()
 }

 // 뷰컨트롤러에 추가 된 뷰모델 속성의 실제 ViewModel을 저장하고, bind() 뷰모델 메서드를 자동으로 호출하는 메서드를 구현한다.
 extension ViewModelBindableType where Self: UIViewController {
 // 바인드 뷰모델 메소드를 자동으로 호출하는 메서드를 구현한다.
 mutating func bind(viewModel: Self.ViewModelType) {
     self.viewModel = viewModel
     loadViewIfNeeded()
     bindViewModel()
 }
 }
 */
