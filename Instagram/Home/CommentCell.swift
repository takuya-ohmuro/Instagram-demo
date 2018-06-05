//
//  CommentCell.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/06/04.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment:Comment? {
        didSet{
            guard let comment = comment else { return }
            let attributeText = NSMutableAttributedString(string: comment.user.userName, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)])
            attributeText.append(NSMutableAttributedString(string: "  " + comment.text, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)]))
            textView.attributedText = attributeText
            profileImage.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    let textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    let profileImage:CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImage)
        addSubview(textView)
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 40, height: 40)
        profileImage.layer.cornerRadius = 40 / 2
        textView.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: -4, paddingBottom: -4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
