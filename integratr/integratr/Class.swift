import Foundation
class Class{
    var name: String
    /*var lectureTimes: [TimeSlot]
    var tutorialTimes: [TimeSlot]
    var labTimes: [TimeSlot]*/
    var timeSlots: [TimeSlot]
    init (name: String) {
        self.name = name
        //self.lectureTimes = []
        //self.tutorialTimes = []
        //self.labTimes = []
        self.timeSlots = []
    }
    /*func addLectureTimeSlot(day: Days, time: Time) {
        lectureTimes.append(TimeSlot(day: day, time: time))
    }
    func addTutorialTimeSlot(day: Days, time: Time) {
        tutorialTimes.append(TimeSlot(day: day, time: time))
    }
    func addLabTimeSlot(day: Days, time: Time) {
        labTimes.append(TimeSlot(day: day, time: time))
    }*/
    func addTimeSlots(times: [TimeSlot]) {
        self.timeSlots += times
    }
    func changeName(name: String) {
        self.name = name
    }
}
