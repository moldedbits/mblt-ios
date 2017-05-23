//
//  TimesheetsTableViewController.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 21/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TimesheetsTableViewController: UITableViewController, ActivityIndicatorPresenter {
    
    let disposeBag = DisposeBag()
    var viewModel: TimesheetsViewModel!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    convenience init(viewModel: TimesheetsViewModel) {
        self.init()
        
        self.viewModel = viewModel
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Timesheets"
        setupTableView()
        setupNavigationBar()
        setupRxBindings()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.register(TimesheetTableViewCell.nib, forCellReuseIdentifier: String(describing: TimesheetTableViewCell.self))
    }
    
    private func setupNavigationBar() {
        let addTimesheetBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addTimesheetBarButton.rx.tap
            .map { _ in true }
            .bind(to: viewModel.addTimesheet)
            .addDisposableTo(disposeBag)
        
        navigationItem.rightBarButtonItems = [addTimesheetBarButton]
    }
    
    private func setupRxBindings() {
       let timesheetSignal = viewModel.getTimesheets()
            .trackActivity(viewModel.activityIndicator)
            .asDriver(onErrorJustReturn: [])
        
        timesheetSignal.drive(tableView.rx.items) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TimesheetTableViewCell.self), for: IndexPath(row: row, section: 0)) as! TimesheetTableViewCell
                cell.configure(withDelegate: item)
                
                return cell
        }.addDisposableTo(disposeBag)
        
        viewModel.activityIndicator
            .distinctUntilChanged()
            .drive(onNext: { [unowned self] active in
                self.view.endEditing(true)
                _ = active ? self.showActivityIndicator() : self.hideActivityIndicator()
            })
            .addDisposableTo(disposeBag)
    }
}
