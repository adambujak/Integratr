//
//  Settings.swift
//  integratr
//
//  Created by Adam Bujak on 2018-07-10.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import UIKit

class Settings: UIViewController {
   
    @IBAction func logOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "macid")
        UserDefaults.standard.removeObject(forKey: "password")
        performSegue(withIdentifier: "logOut", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
