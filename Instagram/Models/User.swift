//
//  User.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/30.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import Foundation

struct  User{
    let userName:String
    let profileImageUrl:String
    init(dictionary:[String:Any]) {
        self.userName = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
