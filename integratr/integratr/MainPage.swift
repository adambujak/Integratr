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
    
    @IBAction func clearButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "name")
    }
    override func viewDidLoad() {
        
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
        GlobalVariables.webView.webView.frame = CGRect(x: 0, y:500, width:300, height:300)
        view.addSubview(GlobalVariables.webView.webView)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
