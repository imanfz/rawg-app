//
//  StringExtension.swift
//  RAWG
//
//  Created by Iman Faizal on 24/08/21.
//

import Foundation

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
    }
    
}

extension Date {
    
    func toString(withFormat format: String = "d MMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
    
}
