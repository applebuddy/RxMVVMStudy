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
    @IBOutlet var deleteButton: UIToolbar!
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
        // 09-05) 편집직후에 메모보기에 편집내용이 적용되지 않는 문제가 발생했습니다.
        // - 지금부터 해당 문제를 해결해보도록 하겠습니다.
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx.disposeBag)
//        backButton.rx.action = viewModel.popAction
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = backButton

        // 09-09) throttle 연산자를 활용하면 DoubleTap을 막을 수 있습니다. throttle 연산자로 tap이벤트는 0.5초마다 하나씩만 전달됩니다.
        // - 이로써 shareButton은 tap속성을 갖게 됩니다. 반면 편집버튼은 action을 사용하고 있습니다.
        // ★ actiion방식과 rx.tap방식이 각각 어떤 장단점을 갖고 있는지 어떤 상황에서 활용하면 좋을 지 확인해보시기 바랍니다.
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
