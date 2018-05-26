//
//  LibBook.swift
//  integratr
//
//  Created by Adam Bujak on 2018-05-26.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import UIKit
import WebKit
class LibBook: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let libView = WKWebView()
        let url = URL(string: "https://library.mcmaster.ca/mrbs/")!
        let request = URLRequest(url: url)
        libView.frame = CGRect(x: 0, y:75, width: self.view.frame.size.width, height:self.view.frame.size.height)
        libView.load(request)
        view.addSubview(libView)
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
