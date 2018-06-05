//
//  Comments.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/06/04.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
