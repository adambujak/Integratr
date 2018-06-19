//
//  User.swift
//  integratr
//
//  Created by Adam Bujak on 2018-06-09.
//  Copyright © 2018 Adam Bujak. All rights reserved.
//

import Foundation

class User {
    var age = 17
    var name = ""
    var MACID = ""
    var password = ""
    func setAge(age: Int) {
        self.age = age
    }
    func setName(name: String){
        self.name = name
    }
    func setMACID(MACID: String){
        self.MACID = MACID
    }
    func setPassword(password: String){
        self.password = password
    }
    func getAge() -> Int {
        return age
    }
    func getName() -> String {
        return name
    }
    func getMACID() -> String {
        return MACID
    }
    func getPassword() -> String {
        return password
    }
}
