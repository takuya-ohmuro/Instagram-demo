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
            textLabel.text = comment?.text
        }
    }
    let textLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.backgroundColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: -4, paddingBottom: -4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
