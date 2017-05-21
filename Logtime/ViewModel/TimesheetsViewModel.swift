//
//  TimesheetsViewModel.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 21/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import RxSwift
import Moya_ObjectMapper


struct TimesheetsViewModel {
    
    var authorizedProvider: AuthorizedNetworking!
    
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


extension Date {
    static let dateFormatter = DateFormatter()
    
    static func string(from date: Date?, withFormat format: String = "dd/mm/yy") -> String {
        guard let date = date else { return "" }
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
