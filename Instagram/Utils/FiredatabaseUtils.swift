//
//  FiredatabaseUtils.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/31.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import Foundation
import Firebase
extension Database {
    static func fetchUserWithUID(uid:String,completion:@escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String:Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
        }) { (err) in
            print("Faild to fetch user for post:",err)
        }
    }
}
