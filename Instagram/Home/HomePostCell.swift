//
//  HomePostCell.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/30.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post:Post)
    func didLike(for cell:HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    var delegate:HomePostCellDelegate?
    
    var post:Post?{
        didSet{
            guard let imageUrl = post?.imageUrl else { return }
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected") .withRenderingMode(.alwaysOriginal): #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            
            photoImageView.loadImage(urlString:imageUrl )
            userNameLabel.text = "TEST USERNAME"
            
            userNameLabel.text = post?.user.userName
            guard let profileImage = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(urlString: profileImage)
//            captionLabel.text = post?.caption
            setupAttributedCaption()
        }
    }
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        let attributeText = NSMutableAttributedString(string: post.user.userName, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14)])
        attributeText.append(NSMutableAttributedString(string: "  \(post.caption)", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)]))
        attributeText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 4)]))
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributeText.append(NSMutableAttributedString(string: timeAgoDisplay, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.gray]))
        captionLabel.attributedText = attributeText
    }
    let userProfileImageView:CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()
    
    let photoImageView:CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let userNameLabel:UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let oprionButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("●●●", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 7)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    lazy var likeButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return btn
    }()
    @objc func handleLike() {
        print("handle like Button")
        delegate?.didLike(for: self)
    }
    lazy var commentButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return btn
    }()
    @objc func handleComment() {
        print("comment")
        guard let post = post else { return }
        delegate?.didTapComment(post:post)
    }
    let sendMessageButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    let bookmarkButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    let captionLabel:UILabel = {
        let label = UILabel()
       
       
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(oprionButton)
        addSubview(photoImageView)
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        userNameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom:photoImageView.topAnchor, right: oprionButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        oprionButton.anchor(top:topAnchor , left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 44, height: 0)
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo:widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
    }
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendMessageButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingRight: 0, paddingBottom: 0, width: 120, height: 50)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 40, height: 50)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: -8, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
