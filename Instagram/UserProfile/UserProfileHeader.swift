//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/21.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user:User? {
        didSet {
            setupProfileImage()
            
            userNameLabel.text = user?.userName
        }
    }
    let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        return iv
    }()
    
    let gridButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        
        return button
    }()
    let listButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    let bookButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    let userNameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let postLabel:UILabel = {
        let label = UILabel()
        
        let attribute = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)])
        attribute.append(NSMutableAttributedString(string: "posts", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.lightGray]))
        label.attributedText = attribute
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followingLabel:UILabel = {
        let label = UILabel()
        let attribute = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)])
        attribute.append(NSMutableAttributedString(string: "following", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.lightGray]))
        label.attributedText = attribute
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followersLabel:UILabel = {
        let label = UILabel()
        let attribute = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)])
        attribute.append(NSMutableAttributedString(string: "followers", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.lightGray]))
        label.attributedText = attribute
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let editingProfileButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        
        setupButtonToolBar()
        
        addSubview(userNameLabel)
        userNameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 26, paddingRight: -6, paddingBottom: 0, width: 0, height: 0)
        
        setupUserStackView()
        
        addSubview(editingProfileButton)
        editingProfileButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 34)
    }
    
    fileprivate func setupUserStackView() {
        let stackView = UIStackView(arrangedSubviews: [postLabel,followersLabel,followingLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: -12, paddingBottom: 0, width: 0, height: 50)
    }
    
    fileprivate func setupButtonToolBar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0.5)
    }
  
    
    fileprivate func setupProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        guard let url = URL(string: profileImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data,response,err) in
            
            if let err = err {
                print("Faild to feach profile Image:",err)
                return
            }
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
