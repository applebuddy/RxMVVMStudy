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

import UIKit

class MemoListViewController: UIViewController, ViewModelBinableType {
    // MARK: - Properties

    var viewModel: MemoListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {}
}
