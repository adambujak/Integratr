//
//  LibBook.swift
//  integratr
//
//  Created by Adam Bujak on 2018-05-26.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import UIKit
import WebKit

class LibBook: UIViewController, WKNavigationDelegate, WKUIDelegate {
    let libraries = ["Thode", "Mills", "Innis"]
    let formatter = DateFormatter()
    var stringDates = [String]()
    var shortDates = [Day]()
    var dates = [Date]()
    var numPeopleArray = [String]()
    var libraryDropDown = DropDownButton()
    var dateDropDown = DropDownButton()
    var numPeopleDropDown = DropDownButton()
    var confirmTimeButton = DropDownButton()
    var durationDropDown = DropDownButton()
    let webView = GlobalVariables.libView.webView
    var queue = FunctionQueue()  // queue to execute web requests in order asynchronously
    var urlString = ""
    
    @IBOutlet weak var bookedLabel: UILabel!
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("loaded")
        queue.remove()()
    }
    func loadURL(urlString: String) {
        let url = URL(string: urlString)
        print(url)
        let request = URLRequest(url: url!)
        func loadRequest(){
            webView.load(request)
        }
        execute(function: loadRequest)
    }
    func loadLoginPage (){
        loadURL(urlString: "https://library.mcmaster.ca/mrbs/admin.php")
    }
    func execute(function: @escaping () -> Void) {  // use this to send something to the response queue, if web view isn't loading it executes right away
        if webView.isLoading{
            queue.add(function: function)
        }
        else{
            function()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.frame = CGRect(x: 0, y:300, width: self.view.frame.size.width, height:200)
        
        self.view.addSubview(self.webView)
        webView.isHidden = true
        loadLoginPage()
        execute(function: signIn)
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        
        fillArrayWithDatesUpToTwoWeeksFromNow(array: &dates)
        stringDates = convertDateArrayToString(array: dates)
        
        shortDates = makeDayArray(days: dates)
        
        var today = shortDates[0]
        
        
        
        
        libraryDropDown = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        libraryDropDown.translatesAutoresizingMaskIntoConstraints = false
        libraryDropDown.setTitle("Pick a Library", for: .normal)
        self.view.insertSubview(libraryDropDown, aboveSubview: self.view)
        libraryDropDown.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        libraryDropDown.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        libraryDropDown.widthAnchor.constraint(equalToConstant: 300).isActive = true
        libraryDropDown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        libraryDropDown.setOptions(options: libraries)
        libraryDropDown.setColor(color: UIColor.lightGray)
        libraryDropDown.onselect = {
            let library = self.libraryDropDown.title(for: .normal)!
            self.urlString = "https://library.mcmaster.ca/mrbs/"
            switch library {
            case "Thode":
                self.urlString += "day.php?year=\(today.year)&month=\(today.month)&day=\(today.day)&area=3"
                break;
            case "Mills":
                self.urlString += "day.php?year=\(today.year)&month=\(today.month)&day=\(today.day)&area=2"
                break;
            case "Innis":
                self.urlString += "day.php?year=\(today.year)&month=\(today.month)&day=\(today.day)&area=1"
                break;
            default:
                break;
            }
            self.dateDropDown.isHidden = false
            self.loadURL(urlString: self.urlString)
        }
    
        confirmTimeButton = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        confirmTimeButton.translatesAutoresizingMaskIntoConstraints = false
        confirmTimeButton.setTitle("Select a Time Slot Then Click Me", for: .normal)
        self.view.insertSubview(confirmTimeButton, belowSubview: dateDropDown)
        confirmTimeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        confirmTimeButton.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 270).isActive = true
        confirmTimeButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        confirmTimeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirmTimeButton.isHidden = true
        confirmTimeButton.setColor(color: UIColor.lightGray)
        confirmTimeButton.onclick = {
            print("clicked")
            self.confirmTimeButton.dismissDropDown();
            self.confirmTimeButton.isHidden = true
            self.webView.isHidden = true
            self.numPeopleDropDown.isHidden = false
        }
        
        
        
        dateDropDown = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dateDropDown.translatesAutoresizingMaskIntoConstraints = false
        dateDropDown.setTitle("Pick a Date", for: .normal)
        self.view.insertSubview(dateDropDown, belowSubview: libraryDropDown)
        dateDropDown.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dateDropDown.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 180).isActive = true
        dateDropDown.widthAnchor.constraint(equalToConstant: 300).isActive = true
        dateDropDown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dateDropDown.setOptions(options: stringDates)
        dateDropDown.isHidden = true
        dateDropDown.setColor(color: UIColor.lightGray)
        
        dateDropDown.onselect = {
            today = self.shortDates[self.dateDropDown.selectedItem]
            let library = self.libraryDropDown.title(for: .normal)!
            
            self.urlString = "https://library.mcmaster.ca/mrbs/"
            switch library {
            case "Thode":
                self.urlString += "day.php?year=\(today.year)&month=\(today.month)&day=\(today.day)&area=3"
                break;
            case "Mills":
                self.urlString += "day.php?year=\(today.year)&month=\(today.month)&day=\(today.day)&area=2"
                break;
            case "Innis":
                self.urlString += "day.php?year=\(today.year)&month=\(today.month)&day=\(today.day)&area=1"
                break;
            default:
                break;
            }
            self.loadURL(urlString: self.urlString)
            self.execute(function: {self.webView.evaluateJavaScript("window.scrollTo(0, 1000)", completionHandler: nil)})
            self.webView.isHidden = false
            self.confirmTimeButton.isHidden = false
        }
   
        
    
        numPeopleDropDown = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        numPeopleDropDown.translatesAutoresizingMaskIntoConstraints = false
        numPeopleDropDown.setTitle("Number of People", for: .normal)
        self.view.insertSubview(numPeopleDropDown, belowSubview: dateDropDown)
        numPeopleDropDown.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        numPeopleDropDown.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 270).isActive = true
        numPeopleDropDown.widthAnchor.constraint(equalToConstant: 300).isActive = true
        numPeopleDropDown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        numPeopleDropDown.isHidden = true
        numPeopleArray = makeNumPeopleArray()
        numPeopleDropDown.setOptions(options: numPeopleArray)
        numPeopleDropDown.setColor(color: UIColor.lightGray)
        numPeopleDropDown.onselect = {
            self.durationDropDown.isHidden = false
        }
        
        
        durationDropDown = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        durationDropDown.translatesAutoresizingMaskIntoConstraints = false
        durationDropDown.setTitle("Duration in Hours", for: .normal)
        self.view.insertSubview(durationDropDown, belowSubview: dateDropDown)
        durationDropDown.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        durationDropDown.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 360).isActive = true
        durationDropDown.widthAnchor.constraint(equalToConstant: 300).isActive = true
        durationDropDown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        durationDropDown.isHidden = true
        durationDropDown.setOptions(options: [".5", "1", "1.5", "2"])
        durationDropDown.setColor(color: UIColor.lightGray)
        durationDropDown.onselect = {
            self.execute(function: self.fillOutForm)
        }
        
        
        self.disableButtons()
    
    }
    func signIn() {
        webView.evaluateJavaScript("document.getElementById('username').value='\(UserDefaults.standard.object(forKey: "id")!)'", completionHandler:  nil)
        webView.evaluateJavaScript("document.getElementById('password').value='\(UserDefaults.standard.object(forKey: "password")!)'", completionHandler: nil)
        webView.evaluateJavaScript("document.getElementsByTagName('input')[17].click()", completionHandler: nil)
        self.queue.add {
            self.enableButtons()
            self.numPeopleDropDown.isHidden = true
        }
        
    }
    func enableButtons(){
      
        libraryDropDown.isHidden = false
        dateDropDown.isHidden = false
        //numPeopleDropDown.isHidden = false
        //durationDropDown.isHidden = false
          
        
    }
    func fillOutForm() {
        let numPeople = self.numPeopleDropDown.title(for: .normal)
        if numPeople != "Number of People" {
            webView.evaluateJavaScript("document.getElementById('name').value='\(UserDefaults.standard.object(forKey: "name")!)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('description').value='\(numPeople)'", completionHandler: nil)
            webView.evaluateJavaScript("document.getElementById('duration').value='\(durationDropDown.title(for: .normal)!)'", completionHandler: nil)
            webView.evaluateJavaScript("document.getElementsByTagName('input')[25].click()", completionHandler: nil)
            self.bookedLabel.text = "Booked!"
        }
        else{
            self.numPeopleDropDown.setColor(color: UIColor.red)
        }
        
    }
    func disableButtons() {
        libraryDropDown.isHidden = true
        dateDropDown.isHidden = true
        numPeopleDropDown.isHidden = true
        durationDropDown.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillArrayWithDatesUpToTwoWeeksFromNow( array: inout [Date]) {
        let date = Date()
        array.append(date)
        var dayAfter: Date
        for i in 1...14 {
            dayAfter = Calendar.current.date(byAdding: .day, value: i, to: date)!
            array.append(dayAfter)
        }
    }
    func convertDateArrayToString(array: [Date]) -> [String] {
        var output = [String]()
        for i in array {
            output.append(formatter.string(from: i))
        }
        return output
    }
    func makeNumPeopleArray() -> [String]{
        var array = [String]()
        array.append("1 person")
        for i in 2...25 {
            array.append("\(i) people")
        }
        return array
    }
    func makeDayArray(days: [Date]) -> [Day]{
        formatter.dateStyle = .short
        var array = [Day]()
        for i in days {
            array.append(Day(string: formatter.string(from: i)))
        }
        return array
    }
    

}
class Day{
    var month: String
    var day: String
    var year: String
    init(string: String){
        month = ""
        day = ""
        year = "20"
        var counter = 0
        for i in string {
            if counter == 0 {
                if i == "/"{
                    counter += 1
                    continue;
                }
                month += String(i)
            }
            else if counter == 1 {
                
                if i == "/" {
                    counter += 1
                    continue;
                }
                day += String(i)
                
            }
            else {
                if i == "/" {
                    break;
                }
                year += String(i)
            }
        }
    }
}
