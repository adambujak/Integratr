//
//  WebView.swift
//  integratr
//
//  Created by Adam Bujak on 2018-06-07.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import Foundation
import WebKit
class WebView {
    var webView = WKWebView()
    var timer: Timer? = nil
    /*
    @objc func signIn(macId: String, password: String) {
        if !webView.isLoading {
            webView.evaluateJavaScript("document.getElementById('userid').value='\(macId)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('pwd').value='\(password)'", completionHandler: nil)
            webView.evaluateJavaScript("document.getElementById('login').submit()", completionHandler: nil)
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkSignIn), userInfo: nil, repeats:true)        }
        
    }
    
    @objc func checkSignIn() {
        func loggedIn(){
            
        }
        let queue = DispatchQueue(label: "queue")
        if !webView.isLoading{
            timer?.invalidate()
            webView.evaluateJavaScript("document.getElementById('login_error').innerHTML;", completionHandler:
                { (html: Any?, error: Error?) in
                    if html == nil{
                        loggedIn()
                    }
                    else if html as! String != " "{
                        
                    }
                    else {
                        loggedIn()
                    }
            })
        }
    }
    @objc func onSignIn() {
        if !webView.isLoading{
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
    }*/ 
}
