import Foundation
enum Days : Int {
    case Sunday = 1;
    case Monday = 2;
    case Tuesday = 3;
    case Wednesday = 4;
    case Thursday = 5;
    case Friday = 6;
    case Saturday = 7;
}
enum ClassType {
    case Lecture
    case Tutorial
    case Lab
    case Error
}
class Time {
    var hour: Int
    var minute: Int
    init (hour: Int, minute: Int){
        self.hour = hour
        self.minute = minute;
    }
    func setTimeFromString (str: String) { //takes 9:30PM or 21:30 format
        var timeArray = str.components(separatedBy: ":")
        var bufferString = timeArray[0]+":"
        var i = 0
        let str1 = timeArray[1]
        while i < str1.count {
            let index = str1.index(str1.startIndex, offsetBy: i)
            if String(str1[index]) == "P" || String(str1[index]) == "A"{ //this part puts 9:30PM format into 9:30:PM format for easy parsings
                bufferString += ":"
            }
            bufferString += String(str1[index])
            i += 1
        }
        timeArray = bufferString.components(separatedBy: ":")
        self.hour = Int(timeArray[0])!
        self.minute = Int(timeArray[1])!
        if timeArray.count > 2 && timeArray[2] == "PM" && self.hour != 12 {
            self.hour += 12
        }
    }
}
class TermInfo {
    var termName: String
    var breakIntervals: [DateInterval] = []
    var interval: DateInterval //classes start here, end here
    init(termName: String) {
        self.termName = termName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        var startDate = Date()
        var endDate = Date()
        if termName == "Fall 2018" {
            startDate = formatter.date(from: "2018/09/04 00:01")!
            endDate = formatter.date(from: "2018/12/05 23:59")!
            let readingWeekStart = formatter.date(from: "2018/10/08 00:01")!
            self.breakIntervals.append(DateInterval(start: readingWeekStart, end: readingWeekStart+604800*5))
        }
        else if termName == "Winter 2019" {
            startDate = formatter.date(from: "2019/01/07 00:01")!
            endDate = formatter.date(from: "2019/12/05 23:59")!
            let readingWeekStart = formatter.date(from: "2019/02/18 00:01")!
            self.breakIntervals.append(DateInterval(start: readingWeekStart, end: readingWeekStart+604800*5))
        }
        interval = DateInterval(start: startDate, end: endDate)
    }
}
class TimeSlot {
    var day: Days
    var time: Time
    var location = ""
    var type: ClassType
    init(day: Days, time: Time, location: String, type: ClassType){
        self.day = day
        self.time = time
        self.location = location
        self.type = type
    }
    func getTimeString() -> String {
        if time.minute == 0 {
            return "\(time.hour):00"
        }
        else {
            return "\(time.hour):30"
        }
    }
}
