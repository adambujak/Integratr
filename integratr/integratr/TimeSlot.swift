import Foundation
enum Days{
    case Monday;
    case Tuesday;
    case Wednesday;
    case Thursday;
    case Friday;
    case Saturday;
    case Sunday;
}
class Time{
    var hour: Int
    var minute: Int
    init (hour: Int, minute: Int){
        self.hour = hour
        self.minute = minute;
    }
}
class TimeSlot{
    var day: Days
    var time: Time
    init(day: Days, time: Time){
        self.day = day
        self.time = time
    }
}
