//
//  DateUtil.swift
//  TourMate
//
//  Created by Keane Chan on 7/4/22.
//

import Foundation

final class DateUtil {
    private init() {}

    static func shortDurationDesc(from startDateTime: DateTime, to endDateTime: DateTime,
                                  on date: Date) -> String {
        let dayStartDate = date
        let dayEndDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        if startDateTime.date <= dayStartDate && endDateTime.date >= dayEndDate {
            return "All day"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short

        let startDateComponents = Calendar
            .current
            .dateComponents(in: startDateTime.timeZone, from: startDateTime.date)
        let startDate = Calendar.current.date(from: DateComponents(year: startDateComponents.year,
                                                                   month: startDateComponents.month,
                                                                   day: startDateComponents.day))!
        let endDateComponents = Calendar
            .current
            .dateComponents(in: endDateTime.timeZone, from: endDateTime.date)
        let endDate = Calendar.current.date(from: DateComponents(year: endDateComponents.year,
                                                                 month: endDateComponents.month,
                                                                 day: endDateComponents.day))!

        var start = dateFormatter.string(from: date)
        var end = dateFormatter.string(from: date)
        if startDate == date {
            dateFormatter.timeZone = startDateTime.timeZone
            start = dateFormatter.string(from: startDateTime.date)
        }
        if endDate == date {
            dateFormatter.timeZone = endDateTime.timeZone
            end = dateFormatter.string(from: endDateTime.date)
        }
        return "\(start) - \(end)"
    }

    static func defaultDateDisplay(date: Date, at timeZone: TimeZone,
                                   dateStyle: DateFormatter.Style = .long,
                                   timeStyle: DateFormatter.Style = .short) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
}
