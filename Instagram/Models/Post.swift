//
//  Post.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/25.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import Foundation
struct Post {
    let user:User
    let imageUrl:String
    let caption:String
    
    init(user:User,dictionary:[String:Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
    
}
