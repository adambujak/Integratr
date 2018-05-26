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
    
    
    var Classes: [Class] = []
    let webView = WKWebView()

    @IBOutlet weak var macid: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UILabel!
    
   
    var counter = 0;
    @IBAction func signInTouch(_ sender: Any) {
        
        getClasses(macId: macid.text!, password: password.text!)
        
        
    }
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://mosaic.mcmaster.ca")!
        let request = URLRequest(url: url)
        webView.frame = CGRect(x: 0, y:500, width:300, height:300)
        webView.load(request)
        view.addSubview(webView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getClasses(macId: String, password: String){
        var str : Any?
        if webView.isLoading {
            
        }
        else{
            if counter == 0 {
                webView.evaluateJavaScript("document.getElementById('userid').value='\(macId)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('pwd').value='\(password)'", completionHandler: nil)
                webView.evaluateJavaScript("document.getElementById('login').submit()", completionHandler: {(html: Any?, error: Error?) in
                     print("done")
                })
                
            
                
                counter = 1;
                
            }
                
            else if counter == 1{
                webView.evaluateJavaScript("document.getElementById('login_error').innerHTML;", completionHandler:
                    { (html: Any?, error: Error?) in
                        if html == nil{
                             self.login.text = ""
                        }
                        else if html as! String != " "{
                            self.login.text = "Incorrect username or password!"
                        }
                        else{
                             self.login.text = ""
                        }
                    })
                webView.evaluateJavaScript("document.getElementById('win0divPTNUI_LAND_REC_GROUPLET$5').click();", completionHandler:  nil)
                counter = 3;
            }
            else if counter == 3{
                webView.evaluateJavaScript("var iframe = document.getElementById('ptifrmtgtframe');", completionHandler: nil)
                webView.evaluateJavaScript("var innerDoc = iframe.contentDocument || iframe.contentWindow.document;", completionHandler: nil)
                webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').value = '1002';", completionHandler: nil)
                webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').onchange();", completionHandler: nil)
                webView.evaluateJavaScript("innerDoc.getElementById('DERIVED_SSS_SCL_SSS_GO_1').click();", completionHandler:  nil)
                counter = 4
                
            }
            else {
                webView.evaluateJavaScript("var iframe = document.getElementById('ptifrmtgtframe');", completionHandler: nil)
                webView.evaluateJavaScript("var innerDoc = iframe.contentDocument || iframe.contentWindow.document;", completionHandler: nil)
                
                webView.evaluateJavaScript("innerDoc.getElementById('MTG_SCHED$1').innerHTML", completionHandler:
                    { (html: Any?, error: Error?) in
                        str = html
                        print(html)
                        var df:String = html as! String
                        print(df)
                })
                
            }
            
        }
    }

}


