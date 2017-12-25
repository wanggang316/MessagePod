//
//  MessageKitDateFormatter.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import Foundation


open class MessageKitDateFormatter {
    
    // MARK: - Properties
    
    public static let shared = MessageKitDateFormatter()
    
    private let formatter = DateFormatter()
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Methods
    
    public func string(from date: Date) -> String {
        configureDateFormatter(for: date)
        return formatter.string(from: date)
    }
    
    public func attributedString(from date: Date, with attributes: [NSAttributedStringKey: Any]) -> NSAttributedString {
        let dateString = string(from: date)
        return NSAttributedString(string: dateString, attributes: attributes)
    }
    
    open func configureDateFormatter(for date: Date) {
        switch true {
        case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
            formatter.doesRelativeDateFormatting = true
            formatter.dateStyle = .short
            formatter.timeStyle = .short
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
            formatter.dateFormat = "EEEE h:mm a"
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
            formatter.dateFormat = "E, d MMM, h:mm a"
        default:
            formatter.dateFormat = "MMM d, yyyy, h:mm a"
        }
    }
    
}
