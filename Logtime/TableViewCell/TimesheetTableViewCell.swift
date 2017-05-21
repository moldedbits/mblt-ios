//
//  TimesheetTableViewCell.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 21/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import UIKit

class TimesheetTableViewCell: UITableViewCell {

    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var workedHourLabel: UILabel! {
        didSet {
            workedHourLabel.textAlignment = .right
        }
    }
    @IBOutlet weak var timesheetDateLabel: UILabel! {
        didSet {
            timesheetDateLabel.textAlignment = .right
        }
    }
    @IBOutlet weak var standupNotesLabel: UILabel! {
        didSet {
            standupNotesLabel.numberOfLines = 0
            standupNotesLabel.lineBreakMode = .byWordWrapping
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withDelegate delegate: TimesheetCellPresentable) {
        projectNameLabel.text = delegate.projectName
        workedHourLabel.text = delegate.workedHour
        timesheetDateLabel.text = delegate.timesheetDate
        standupNotesLabel.text = delegate.standupNotes
    }
    
}

