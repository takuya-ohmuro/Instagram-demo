//
//  UserSearchCell.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/31.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    var user:User? {
        didSet {
            userNameLabel.text = user?.userName
            
            guard let image = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: image)
        }
    }
    
    let profileImageView:CustomImageView =  {
        let iv = CustomImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50 / 2
        iv.clipsToBounds = true
        return iv
    }()
    let userNameLabel:UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.font  = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(userNameLabel)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userNameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: userNameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}