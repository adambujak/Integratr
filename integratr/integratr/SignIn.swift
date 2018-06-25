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
                GlobalVariables.execute(function: webView.signIn)
                GlobalVariables.mainQueue.add(function: {}) // when loading mosaic something weird happens so it stops loading even when it hasn't.
                GlobalVariables.mainQueue.add(function: webView.checkSignIn)
                GlobalVariables.mainQueue.add(function: webView.getName)
                GlobalVariables.mainQueue.add(function: goToMainPage)

                //webView.execute(function: webView.getName)
                //webView.execute(function: webView.goToCoursePageFromStudentCentre)
            }
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
        GlobalVariables.mainQueue.remove()()
    }
    
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// main()
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "name") == nil {
            let url = URL(string: "https://mosaic.mcmaster.ca")!
            let request = URLRequest(url: url)
            
            webView.webView.load(request)
            webView.webView.uiDelegate = self
            webView.webView.navigationDelegate = self
            
            webView.webView.frame = CGRect(x: 0, y:500, width:300, height:300)
            view.addSubview(webView.webView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "name") != nil {
            goToMainPage()
        }
    }

}


