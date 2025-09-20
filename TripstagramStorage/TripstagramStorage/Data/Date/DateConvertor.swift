import Foundation

class DateConvertor {
    
    static func toInt64(date: Date) -> Int64 {
        return Int64(date.timeIntervalSince1970)
    }
    
    static func toInt64(nullableDate date: Date?) -> Int64? {
        guard let date = date else { return nil }
        return toInt64(date: date)
    }
    
    static func toDate(int64: Int64) -> Date {
        return Date(timeIntervalSince1970: Double(int64))
    }
    
    static func toDate(nullableInt64 int64: Int64?) -> Date? {
        guard let int64 = int64 else { return nil }
        return toDate(int64: int64)
    }
}
