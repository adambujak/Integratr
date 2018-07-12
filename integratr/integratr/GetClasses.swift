//
//  GetClasses.swift
//  integratr
//
//  Created by Adam Bujak on 2018-06-07.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//  Gets classes from mosaic
//

import UIKit

class GetClasses: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! classCell
        cell.className.text = classNames[indexPath.row]
        cell.time.text = times[indexPath.row]
        cell.duration.text = durations[indexPath.row]
        cell.location.text = locations[indexPath.row]
        return cell
    }
    
    var classNames : [String] = []
    var times : [String] = []
    var locations : [String] = []
    var durations : [String] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sundayButton: UIBarButtonItem!
    @IBOutlet weak var mondayButton: UIBarButtonItem!
    @IBOutlet weak var tuesdayButton: UIBarButtonItem!
    @IBOutlet weak var wednesdayButton: UIBarButtonItem!
    @IBOutlet weak var thursdayButton: UIBarButtonItem!
    @IBOutlet weak var fridayButton: UIBarButtonItem!
    @IBOutlet weak var saturdayButton: UIBarButtonItem!
    @IBAction func sundayTouch(_ sender: Any) {
        makeAllButtonsWhiteExcept(button: sundayButton)
    }
    @IBAction func mondayTouch(_ sender: Any) {
        makeAllButtonsWhiteExcept(button: mondayButton)
    }
    @IBAction func tuesdayTouch(_ sender: Any) {
        makeAllButtonsWhiteExcept(button: tuesdayButton)
    }
    @IBAction func wednesdayTouch(_ sender: Any) {
        makeAllButtonsWhiteExcept(button: wednesdayButton)
    }
    @IBAction func thursdayTouch(_ sender: Any) {
        makeAllButtonsWhiteExcept(button: thursdayButton)
    }
    @IBAction func fridayTouch(_ sender: Any) {
        makeAllButtonsWhiteExcept(button: fridayButton)
    }
    @IBAction func saturdayTouch(_ sender: Any) {
        makeAllButtonsWhiteExcept(button: saturdayButton)
    }
    
    
    
    var termInfo: TermInfo = TermInfo(termName: "Fall 2018") // setting manually for now, change this later
    var termDropDown = DropDownButton()
    var classes : [Class] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red:0.51, green:0.00, blue:0.17, alpha:1.0)
        }
        UIApplication.shared.statusBarStyle = .lightContent
        scrape()
        tableView.rowHeight = 85
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //var name = "ENGINEER 2MM3-C01<br>LEC (12015)"
        //var times = "TuWe 09:30 - 10:20<br>CNH 103"
       // makeClass(name: name, times: times)
        
    }
    func makeAllButtonsWhiteExcept(button: UIBarButtonItem) { ///rename - errr and inapropriate
        sundayButton.tintColor = UIColor.white
        mondayButton.tintColor = UIColor.white
        tuesdayButton.tintColor = UIColor.white
        wednesdayButton.tintColor = UIColor.white
        thursdayButton.tintColor = UIColor.white
        fridayButton.tintColor = UIColor.white
        saturdayButton.tintColor = UIColor.white
        button.tintColor = UIColor(red:1.00, green:0.75, blue:0.34, alpha:1.0)
        emptyArraysForTable()
        fillArraysForTable(day: returnDayFromString(str: button.title!))
    }
    func emptyArraysForTable() {
        classNames = []
        times = []
        locations = []
        durations = []
    }
    func fillArraysForTable(day: Days) {
        for i in classes {
            for j in i.timeSlots{
                if j.day == day {
                    let bufferName = i.name + " - " + "\(j.type)"
                    classNames.append(bufferName)
                    times.append(j.getTimeString())
                    locations.append(j.location)
                    durations.append("1h")
                }
            }
        }
        tableView.reloadData() //move this to the make all buttons
    }
    
    
    func findNextDay(timeSlot: TimeSlot) -> Date {
        var date = Date()
        while timeSlot.day.rawValue != Calendar.current.dateComponents([.weekday], from: date).weekday! { // adds days to current day until it reaches the day of the week we want
            date += 86400 //add one day
        }
        return Calendar.current.date(bySettingHour: timeSlot.time.hour, minute: timeSlot.time.minute, second: 0, of: date)!
    }
    func makeDateArray(date: Date, interval: DateInterval, breaks: [DateInterval]) -> [Date] {
        var bufferDate = date
        while (bufferDate < interval.start) { //this adds weeks to buffer date to bring the date into the specified interval
            bufferDate += 604800 // add 1 week
            
        }
        var returnDates: [Date] = []
        while bufferDate < interval.end {
            for i in breaks {
                if bufferDate > i.start && bufferDate < i.end { // if there are breaks, don't add classes.
                    bufferDate += 604800 // add 1 week
                    continue
                }
            }
            returnDates.append(bufferDate)
            bufferDate += 604800 // add 1 week
        }
        return returnDates
    }
    
    func scrape (){ // just to call the function that scrapes the classes
        scrapeClasses(i: 0)
    }
    func scrapeClasses(i: Int) {
        GlobalVariables.webView.webView.evaluateJavaScript("var iframe = document.getElementById('ptifrmtgtframe');", completionHandler: nil)
        GlobalVariables.webView.webView.evaluateJavaScript("var innerDoc = iframe.contentDocument || iframe.contentWindow.document;", completionHandler: nil)
        GlobalVariables.webView.webView.evaluateJavaScript("innerDoc.getElementById('CLASS_NAME$span$\(i)').innerHTML", completionHandler:  { (html: Any?, error: Error?) in
            let name = html as! String
            GlobalVariables.webView.webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSR_MTG_SCHED_LONG$\(i)').innerHTML", completionHandler:  { (html: Any?, error: Error?) in
                let time = html as! String
                if time != "Room:&nbsp; TBA" {
                    self.makeClass(name: self.stripNameStringToCourseCode(str: name), times: time, classType: self.getClassTypeFromName(str: name))
                }
                GlobalVariables.webView.webView.evaluateJavaScript("innerDoc.getElementById('CLASS_NAME$span$\(i+1)').innerHTML", completionHandler:  { (html: Any?, error: Error?) in
                    if html != nil {
                        self.scrapeClasses(i: i+1)
                    }
                    else{
                        self.printClasses() // done scrape term info here and set term info
                    }
                    
                })
            })
        }
        )
    }
    func getClassTypeFromName(str: String) -> ClassType {
        var strArray = str.components(separatedBy: "-")
        var str1 = strArray[1]
        let index = str1.index(str1.startIndex, offsetBy: 0)
        var classTypeChar = String(str1[index])
        if classTypeChar == "C" {
            return ClassType.Lecture
        }
        if classTypeChar == "T" {
            return ClassType.Tutorial
        }
        if classTypeChar == "L" {
            return ClassType.Lab
        }
        return ClassType.Error
    }
    func printClasses() {
        print(classes.isEmpty, "jfd:")
        for i in classes {
            print(i.name, "className")
            for j in i.timeSlots {
                print(j.time.hour, ":" , j.time.minute, j.day, "at: ", j.location, j.type)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeClass (name: String, times: String, classType: ClassType) { //rename - innappropriate function name, as it doesn't just make new classes but also adds time slots to existing ones
        var schoolClass = Class(name: name)
        var classIndex = checkForClass(name: name)
        if classIndex == -1 {
            classes.append(schoolClass)
            classIndex = classes.count - 1
        }
        classes[classIndex].addTimeSlots(times: makeTimeSlots(times: times, classType: classType))
        
    }
    func stripNameStringToCourseCode(str: String) -> String {
        var strArray = str.components(separatedBy: " ")
        return strArray[1].components(separatedBy: "-")[0]
    }
    func checkForClass(name: String) -> Int {
        for i in 0..<classes.count {
            if classes[i].name == name {
                return i
            }
        }
        return -1
    }
    func getDaysTimeAndLocation(times: String, location: String) -> [String] {
        var bufferArray = times.components(separatedBy: "-") //[0] = TuWe 9:30AM [1] = 10:20AM
        var timeSlotComponentArray = bufferArray[0].components(separatedBy: " ") //[0] = TuWe [1] = 9:30AM
        let startTime = timeSlotComponentArray[1]
        let endTime = bufferArray[1].components(separatedBy: " ")[1]
        let location = location
        let days = timeSlotComponentArray[0]
        return [days, startTime, endTime, location]
    }
    func makeTimeSlots(times: String, classType: ClassType) -> [TimeSlot] { //pass in the form TuWe 9:30AM - 10:20AM<br>\nCNH 103
        var timeSlots: [TimeSlot] = []
        
        var strArray = getRidOfLines(str: times).components(separatedBy: "<br>") //[0] = TuWe 9:30AM - 10:20AM [1] = CNH 103
        for i in strArray {
            print(i) //get rid of /n
        }
        for i in 0 ..< strArray.count/2 {
            print(strArray[i*2], "name")
            var daysTimeLocation = getDaysTimeAndLocation(times: strArray[i*2], location: strArray[(i*2)+1])
            let start = daysTimeLocation[0].index(daysTimeLocation[0].startIndex, offsetBy: (0))
            var end = daysTimeLocation[0].index(daysTimeLocation[0].startIndex, offsetBy: (2))
            let range = start..<end
            let firstDay = String(daysTimeLocation[0][range])
            if !isDay(str: firstDay) {
                return timeSlots
            }
            timeSlots += getTimeSlotsFromString(daysStr: daysTimeLocation[0], startTime: daysTimeLocation[1], endTime: daysTimeLocation[2], location: daysTimeLocation[3], classType: classType)
        }
        return timeSlots
    }
    func getRidOfLines(str: String) -> String {
        var strArray = str.components(separatedBy: "\n")
        var returnString = ""
        for i in strArray {
            if i != "\n" {
                returnString += i
            }
        }
        return returnString
    }
    func getTimeSlotsFromString (daysStr: String, startTime: String, endTime: String, location: String, classType: ClassType) -> [TimeSlot] { // pass times in the form of either 22:30 or 9:30AM, dayStr -> TuWeTh
        var timeSlots : [TimeSlot] = []
        var numberOfDays = daysStr.count / 2
        var time = Time(hour:0, minute: 0)
        time.setTimeFromString(str: startTime)
        for i in 0 ..< numberOfDays {
            let start = daysStr.index(daysStr.startIndex, offsetBy: (i*2))
            let end = daysStr.index(daysStr.startIndex, offsetBy: ((i+1)*2))
            let range = start..<end
            timeSlots.append(TimeSlot(day: returnDayFromString(str: String(daysStr[range])), time: time, location: location, type: classType))
        }
        return timeSlots
    }

    func isDay(str: String) -> Bool {
        switch str {
        case "Mo":
            return true
        case "Tu":
            return true
        case "We":
            return true
        case "Th":
            return true
        case "Fr":
            return true
        case "Sa":
            return true
        case "Su":
            return true
        default:
            return false
        }
    }
    func returnDayFromString(str: String) -> Days {
        switch str {
        case "Mo":
            return Days.Monday
        case "Tu":
            return Days.Tuesday
        case "We":
            return Days.Wednesday
        case "Th":
            return Days.Thursday
        case "Fr":
            return Days.Friday
        case "Sa":
            return Days.Saturday
        case "Su":
            return Days.Sunday
        default:
            return Days.Tuesday
        }    }
}
