//
//  MainPage.swift
//  integratr
//
//  Created by Adam Bujak on 2018-06-02.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import UIKit
import WebKit
import EventKit

class MainPage: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.white
        }
        UIApplication.shared.statusBarStyle = .lightContent
        let store = EKEventStore()
        func createEventinTheCalendar(with title:String, forDate eventStartDate:Date, toDate eventEndDate:Date) {
            
            store.requestAccess(to: .event) { (success, error) in
                if  error == nil {
                    let event = EKEvent.init(eventStore: store)
                    event.title = title
                    event.calendar = store.defaultCalendarForNewEvents // this will return deafult calendar from device calendars
                    event.startDate = eventStartDate
                    event.endDate = eventEndDate
                    
                    let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -3600, since: event.startDate))
                    event.addAlarm(alarm)
                    
                    do {
                        try store.save(event, span: .thisEvent)
                        //event created successfullt to default calendar
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    
                } else {
                    //we have error in getting access to device calnedar
                    print("error = \(String(describing: error?.localizedDescription))")
                }
            }
        }
        
        createEventinTheCalendar(with: "d", forDate: Date(), toDate: Date())
    
        super.viewDidLoad()
        welcomeLabel.text! += ", \(UserDefaults.standard.object(forKey: "name")!)!"
      
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
