import Foundation
class Class{
    let name: String
    var lectureTimes: [TimeSlot]
    var tutorialTimes: [TimeSlot]
    var labTimes: [TimeSlot]
    init (name: String) {
        self.name = name
        lectureTimes = []
        tutorialTimes = []
        labTimes = []
    }
    func addLectureTimeSlot(day: Days, time: Time) {
        lectureTimes.append(TimeSlot(day: day, time: time))
    }
    func addTutorialTimeSlot(day: Days, time: Time) {
        tutorialTimes.append(TimeSlot(day: day, time: time))
    }
    func addLabTimeSlot(day: Days, time: Time) {
        labTimes.append(TimeSlot(day: day, time: time))
    }
}
