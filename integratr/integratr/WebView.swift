//
//  WebView.swift
//  integratr
//
//  Created by Adam Bujak on 2018-06-07.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import Foundation
import WebKit
class WebView {//:UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView = WKWebView()
    var timer: Timer = Timer()
    
    
    /*init() {
     
     }*/
    // override func viewDidLoad() {
    //      webView.uiDelegate = self
    //      webView.navigationDelegate = self
    //  }
    // func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    //     print("done")
    // }
    
    // call a function, if loading, add to queue
    
    // delegate on load will call functions in queue in order
    
    
    func signIn() {
        
        webView.evaluateJavaScript("document.getElementById('userid').value='\(GlobalVariables.MACID)'", completionHandler:  nil)
        webView.evaluateJavaScript("document.getElementById('pwd').value='\(GlobalVariables.PASSWORD)'", completionHandler: nil)
        webView.evaluateJavaScript("document.getElementById('login').submit()", completionHandler: nil)
        timer = Timer(timeInterval: 0.1, target: self, selector: #selector(checkSignIn), userInfo: nil, repeats: true)
            
    }
        

    @objc func checkSignIn() {
        if webView.isLoading {
            return
        }
        timer.invalidate()
        webView.evaluateJavaScript("document.getElementById('login_error').innerHTML;", completionHandler:
            { (html: Any?, error: Error?) in
                if html == nil{
                    UserDefaults.standard.set(GlobalVariables.MACID, forKey: "id")
                    UserDefaults.standard.set(GlobalVariables.PASSWORD, forKey: "password")
                    self.goToStudentCenter()
                }
                else if html as! String != " "{
                    GlobalVariables.signInStatusLabel.text = "Incorrect username or password!"
                    GlobalVariables.mainQueue.empty()
                }
                else {
                    UserDefaults.standard.set(GlobalVariables.MACID, forKey: "id")
                    UserDefaults.standard.set(GlobalVariables.PASSWORD, forKey: "password")
                    self.goToStudentCenter()
                }
        })
    
    }
    
    func goToStudentCenter() {
        webView.evaluateJavaScript("document.getElementById('win0divPTNUI_LAND_REC_GROUPLET$4').click();", completionHandler: nil)
    }

    @objc func getName() {
        var name = ""
        let queue = DispatchQueue(label: "queue")
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
                    GlobalVariables.mainQueue.remove()() // this is to go to the next page
                    
                    
            })
        }
    }
    
    func goToCoursePageFromStudentCentre() {
        
        webView.evaluateJavaScript("var iframe = document.getElementById('ptifrmtgtframe');", completionHandler: nil)
        webView.evaluateJavaScript("var innerDoc = iframe.contentDocument || iframe.contentWindow.document;", completionHandler: nil)
        webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').value = '1002';", completionHandler: nil)
        webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').onchange();", completionHandler: nil)
        webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSS_GO_1').click();", completionHandler:  nil)
        
    }
    func getCoursesFromCoursePage() {
        
        webView.evaluateJavaScript("var iframe = document.getElementById('ptifrmtgtframe');", completionHandler: nil)
        webView.evaluateJavaScript("var innerDoc = iframe.contentDocument || iframe.contentWindow.document;", completionHandler: nil)
        
        webView.evaluateJavaScript("innerDoc.getElementById('MTG_SCHED$1').innerHTML", completionHandler:
            { (html: Any?, error: Error?) in
               
                
        })
    }
    
}
/*
 GlobalVariables.webView.webView.evaluateJavaScript("var iframe = document.getElementById('ptifrmtgtframe');", completionHandler: nil)
 GlobalVariables.webView.webView.evaluateJavaScript("var innerDoc = iframe.contentDocument || iframe.contentWindow.document;", completionHandler: nil)
 GlobalVariables.webView.webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').value = '1002';", completionHandler: nil)
 GlobalVariables.webView.webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').onchange();", completionHandler: nil)
 GlobalVariables.webView.webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSS_GO_1').click();", completionHandler:  nil)
 GlobalVariables.webView.webView.evaluateJavaScript("innerDoc.getElementById('win0divSSR_DUMMY_RECV1$sels$1$$0').click();", completionHandler:  nil)
 GlobalVariables.webView.webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCT_SSR_PB_GO').click();", completionHandler:  nil)
 
 A*/
