//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by MinKyeongTae on 09/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MemoDetailViewController: UIViewController, ViewModelBinableType {
    // MARK: - Property

    // 07-01) commit(05:36)
    @IBOutlet var listTableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!

    // 09-08) shareButton을 클릭하면, 메모를 공유할 수 있도록 구현해보겠습니다.

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

        // 10-1) deleteAction을 만들고, 버튼과 바인딩 함으로서 삭제 기능을 구현합니다.
        deleteButton.rx.action = viewModel.makeDeleteAction()

        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let memo = self?.viewModel.memo.content else { return }
                let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
    }
}
