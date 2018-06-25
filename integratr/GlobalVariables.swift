//
//  GlobalVariables.swift
//  integratr
//
//  Created by Adam Bujak on 2018-06-19.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import Foundation
import UIKit
class GlobalVariables: UIViewController {
    static var MACID = ""
    static var PASSWORD = ""
    static var signInStatusLabel: UILabel = UILabel()
    static var webView = WebView()
    static func goToMainPage() {
        SignIn().goToMainPage()
    }
    static var mainQueue = FunctionQueue()
    static var libView = WebView()
    static func execute(function: @escaping () -> Void) {  // use this to send something to the response queue, if web view isn't loading it executes right away
        if GlobalVariables.webView.webView.isLoading {
            GlobalVariables.mainQueue.add(function: function)
        }
        else{
            function()
        }
    }
}
