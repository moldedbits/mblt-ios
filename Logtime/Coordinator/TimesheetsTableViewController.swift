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

class TimesheetsTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    var viewModel: TimesheetsViewModel!
    
    convenience init(viewModel: TimesheetsViewModel) {
        self.init()
        
        self.viewModel = viewModel
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.register(TimesheetTableViewCell.nib, forCellReuseIdentifier: String(describing: TimesheetTableViewCell.self))
        setupRxBindings()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func setupRxBindings() {
        viewModel.getTimesheets()
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TimesheetTableViewCell.self), for: IndexPath(row: row, section: 0)) as! TimesheetTableViewCell
                cell.configure(withDelegate: item)
                
                return cell
        }.addDisposableTo(disposeBag)

    }
    
}
