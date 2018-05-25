//
//  Post.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/25.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import Foundation
struct Post {
    let imageUrl:String
    
    init(dictionary:[String:Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
    
}
