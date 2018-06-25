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
    static var libView = WebView()
}
