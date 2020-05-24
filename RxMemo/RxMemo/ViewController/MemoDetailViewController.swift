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

    // 07-09) 먼저 네비게이션 타이틀을 바인딩 하겠습니다.
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        // 07-10) 이어서 테이블 뷰를 바인딩 합니다.
        viewModel.contents
            .bind(to: listTableView.rx.items) { tableView, row, value in
                switch row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value // 10:41
                    return cell
                case 1:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell") else { return UITableViewCell() }
                    cell.textLabel?.text = value
                    return cell // 11:07
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)

        editButton.rx.action = viewModel.makeEditAction()
        // 09-05) 편집직후에 메모보기에 편집내용이 적용되지 않는 문제가 발생했습니다.
        // - 지금부터 해당 문제를 해결해보도록 하겠습니다.
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx.disposeBag)
//        backButton.rx.action = viewModel.popAction
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = backButton
    }
}
