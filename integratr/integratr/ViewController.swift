//
//  ViewController.swift
//  integratr
//
//  Created by Adam Bujak on 2018-03-31.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import UIKit
import Foundation
import WebKit
class ViewController: UIViewController {
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// declarations
    
    let webView = GlobalVariables.webView
    var timer: Timer? = nil // this is used to check every 0.5 sec to see if webview is done loading so that the next step can be excecuted
    @IBOutlet weak var macid: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInStatusLabel: UILabel!
    var MACID: String = ""
    var PASSWORD: String = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// outlets

    @IBAction func signInTouch(_ sender: Any) {
        print(GlobalVariables.name)
        if !webView.isLoading{
            MACID = macid.text!
            PASSWORD = password.text!
            if MACID.count < 3 || MACID.count > 9{
                signInStatusLabel.text = "Invalid MACID!"
            }
            else{
                signInStatusLabel.text = "Loading..."
                signIn(macId: MACID, password: PASSWORD)
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(onSignIn), userInfo: nil, repeats:true)
            }
        }
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// functions

    @objc func signIn(macId: String, password: String) {
        if !webView.isLoading {
            webView.evaluateJavaScript("document.getElementById('userid').value='\(macId)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('pwd').value='\(password)'", completionHandler: nil)
            webView.evaluateJavaScript("document.getElementById('login').submit()", completionHandler: nil)
        }
    }
    
    func checkSignIn() -> Bool {
        var returnValue: Bool = true
        let queue = DispatchQueue(label: "queue")
        if !webView.isLoading{
            queue.sync {
                webView.evaluateJavaScript("document.getElementById('login_error').innerHTML;", completionHandler:
                    { (html: Any?, error: Error?) in
                        if html == nil{
                            returnValue = true
                        }
                        else if html as! String != " "{
                            returnValue = false
                        }
                        else {
                            returnValue = true
                        }
                })
            }
        }
        return returnValue
    }
    @objc func onSignIn() {
        if !webView.isLoading {
            timer?.invalidate()
            let status = checkSignIn()
            if status {
                UserDefaults.standard.set(MACID, forKey: "id")
                UserDefaults.standard.set(PASSWORD, forKey: "password")
                let queue = DispatchQueue(label: "queue")
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(goToStudentCenter), userInfo: nil, repeats:true)
                
                /*
                queue.sync{
                    UserDefaults.standard.set(getName(), forKey: "name")
                }
                goToMainPage()*/
            }
            else {
                self.signInStatusLabel.text = "Incorrect username or password!"
            }
        }
    }
    @objc func goToStudentCenter() {
        if !webView.isLoading{
            timer?.invalidate()
            webView.evaluateJavaScript("document.getElementById('win0divPTNUI_LAND_REC_GROUPLET$5').click();", completionHandler:  nil)
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getName), userInfo: nil, repeats:true)
        }
        
    }
    
    @objc func getName() {
        var name = ""
        let queue = DispatchQueue(label: "queue")
        if !webView.isLoading{
            timer?.invalidate()
            queue.sync{
                webView.evaluateJavaScript("var iframe = document.getElementById('ptifrmtgtframe');", completionHandler: nil)
                webView.evaluateJavaScript("var innerDoc = iframe.contentDocument || iframe.contentWindow.document;", completionHandler: nil)
                webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_TITLE1$78$').innerHTML;", completionHandler:
                        { (html: Any?, error: Error?) in
                            let str = html as! String
                            for char in str {
                                if char == "\'" {
                                    break
                                }
                                name.append(char)
                            }
                        UserDefaults.standard.set(name, forKey: "name")
                        self.goToMainPage() // get this out of here somehow.
                    })
                }
            
        }
    }
    
    @objc func goToMainPage() { // get rid of objc once dispatch group is used.
        self.signInStatusLabel.text = ""
        timer?.invalidate()
        self.performSegue(withIdentifier: "login", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// main()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(GlobalVariables.name)
        GlobalVariables.name = "sadf"
        if UserDefaults.standard.object(forKey: "name") == nil {
            let url = URL(string: "https://mosaic.mcmaster.ca")!
            let request = URLRequest(url: url)
            webView.load(request)
           
            webView.frame = CGRect(x: 0, y:500, width:300, height:300)
            view.addSubview(webView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "name") != nil {
            goToMainPage()
        }
    }

}


