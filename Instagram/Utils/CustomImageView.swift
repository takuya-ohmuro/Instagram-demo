//
//  CustomImageView.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/29.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var LastURLUsedToLoadImage:String?
    
    func loadImage(urlString:String) {
        print("loading Image")
        LastURLUsedToLoadImage = urlString
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:",err)
                return
            }
            if url.absoluteString != self.LastURLUsedToLoadImage{
                return
            }
            
            guard let imageData = data else { return }
            let photoData = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = photoData
            }
            }.resume()
    }
}
