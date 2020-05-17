//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class MemoDetailViewController: UIViewController, ViewModelBinableType {
    // MARK: - Property

    // 07-01) commit(05:36)
    @IBOutlet var listTableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIToolbar!
    @IBOutlet var shareButton: UIBarButtonItem!

    var viewModel: MemoDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {}
}
