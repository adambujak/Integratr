//
//  MainPage.swift
//  integratr
//
//  Created by Adam Bujak on 2018-06-02.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import UIKit

class MainPage: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBAction func clearButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "name")
    }
    override func viewDidLoad() {
        print("3")
        super.viewDidLoad()
        welcomeLabel.text! += ", \(UserDefaults.standard.object(forKey: "name")!)!"
        GlobalVariables.webView.webView.frame = CGRect(x: 0, y:500, width:300, height:300)
        view.addSubview(GlobalVariables.webView.webView)
        
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
