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
class SignIn: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// declarations
    
    let webView = GlobalVariables.webView
    var timer: Timer? = nil // this is used to check every 0.5 sec to see if webview is done loading so that the next step can be excecuted
    @IBOutlet weak var macid: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    var loaded = false
    @IBOutlet weak var signInStatusLabel: UILabel!
    var MACID: String = ""
    var PASSWORD: String = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// outlets

    @IBAction func signInTouch(_ sender: Any) {
        if !webView.webView.isLoading{
            GlobalVariables.MACID = macid.text!
            GlobalVariables.PASSWORD = password.text!
            if GlobalVariables.MACID.count < 3 || GlobalVariables.MACID.count > 9{
                signInStatusLabel.text = "Invalid MACID!"
            }
            else{
                signInStatusLabel.text = "Loading..."
                webView.signIn(macId: GlobalVariables.MACID, password: GlobalVariables.PASSWORD)
                //GlobalVariables.execute(function: webView.signIn)
                //GlobalVariables.mainQueue.add(function: {}) // when loading mosaic something weird happens so it stops loading even when it hasn't.
                ///GlobalVariables.mainQueue.add(function: webView.checkSignIn)
                //GlobalVariables.mainQueue.add(function: webView.getName)
                GlobalVariables.mainQueue.add(function: goToMainPage)
                

                //webView.execute(function: webView.getName)
                //webView.execute(function: webView.goToCoursePageFromStudentCentre)
            }
        }
        else {
            signInStatusLabel.text = "Sorry, try again in a second or two."
        }
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// functions

    func goToMainPage() { // get rid of objc once dispatch group is used.
        self.performSegue(withIdentifier: "login", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // delegate, runs when page done loading
    }
    @objc func notLoading() {
        if !webView.webView.isLoading {
            GlobalVariables.mainQueue.remove()()
            if !webView.webView.isLoading {
                notLoading()
            }
        }
    }
    
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// main()
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://mosaic.mcmaster.ca")!
        let request = URLRequest(url: url)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        GlobalVariables.signInStatusLabel = signInStatusLabel
        GlobalVariables.macidField = macid
        GlobalVariables.passwordField = password
        GlobalVariables.signInButton = signInButton
        NotificationCenter.default.addObserver(self, selector: #selector(SignIn.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignIn.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        webView.webView.load(request)
        webView.webView.uiDelegate = self
        webView.webView.navigationDelegate = self
        if UserDefaults.standard.object(forKey: "macid") != nil {
            if UserDefaults.standard.object(forKey: "macid") as! String != "" {
                macid.isHidden = true
                password.isHidden = true
                signInButton.isHidden = true
                signInStatusLabel.text = "Loading..."
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(start), userInfo: nil, repeats: true)
            }
            
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        macid.resignFirstResponder()
        password.resignFirstResponder()
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    @objc func start() {
        if !webView.webView.isLoading {
            webView.webView.evaluateJavaScript("document.getElementById('userid').value;", completionHandler:
                { (html: Any?, error: Error?) in
                    if html != nil {
                        self.timer?.invalidate()
                        self.webView.signIn(macId: UserDefaults.standard.object(forKey: "macid") as! String, password: UserDefaults.standard.object(forKey: "password") as! String)
                        self.addMainPageToQueue()
                    }
            })
        }
    }
    func addMainPageToQueue() {
        GlobalVariables.mainQueue.add(function: goToMainPage)
    }

}


