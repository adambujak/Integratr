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
class SignIn: UIViewController {
    
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
                webView.signIn(macId:  GlobalVariables.MACID, password:  GlobalVariables.PASSWORD)
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
    
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////// main()
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "name") == nil {
            let url = URL(string: "https://mosaic.mcmaster.ca")!
            let request = URLRequest(url: url)
            webView.webView.load(request)
           
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


