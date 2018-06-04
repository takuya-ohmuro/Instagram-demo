//
//  Comments.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/06/04.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import Foundation

struct Comment {
    let text:String
    let uid:String
    
    init(dictionary:[String:Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
