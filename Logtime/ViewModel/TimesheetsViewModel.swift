//
//  TimesheetsViewModel.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 21/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import RxSwift
import RxSwiftUtilities
import Moya_ObjectMapper


struct TimesheetsViewModel {
    
    let activityIndicator = ActivityIndicator()
    
    var authorizedProvider: AuthorizedNetworking!
    var addTimesheet = Variable<Bool>(false)
    
    init(authorizedProvider: AuthorizedNetworking) {
        self.authorizedProvider = authorizedProvider
    }
    
    func getTimesheets() -> Observable<[TimesheetCellPresentable]> {
        return authorizedProvider.request(.timesheets)
            .debug()
            .mapArray(Timesheet.self)
            .map { timesheets in
                timesheets.map { timesheet in
                    return TimesheetCellViewModel(timesheet: timesheet)
                }
            }
            .catchErrorJustReturn([])
    }
}

protocol TimesheetCellPresentable {
    var projectName: String { get }
    var workedHour: String { get }
    var timesheetDate: String { get }
    var standupNotes: String { get }
}

struct TimesheetCellViewModel: TimesheetCellPresentable {
    var projectName: String
    var workedHour: String
    var timesheetDate: String
    var standupNotes: String
    
    init(timesheet: Timesheet) {
        projectName = timesheet.project.name ?? ""
        workedHour = "\(timesheet.hours ?? 0)"
        timesheetDate = Date.string(from: timesheet.date)
        standupNotes = timesheet.standupDetails ?? ""
    }
}
