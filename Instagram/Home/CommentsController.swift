//
//  CommentsController.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/06/01.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var post:Post? 
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.backgroundColor = .blue
        navigationItem.title = "Comments"
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        fetchComments()
    }
    var comments = [Comment]()
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String:Any] else { return }
            let comment = Comment(dictionary: dictionary)
            self.comments.append(comment)
            self.collectionView?.reloadData()
        }) { (err) in
            print("Faild to observe comments",err)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    lazy var containerView:UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let sumbitButton = UIButton(type: .system)
        sumbitButton.setTitle("Sumbit", for: .normal)
        sumbitButton.setTitleColor(.black, for: .normal)
        sumbitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sumbitButton.addTarget(self, action: #selector(handleSumbit), for: .touchUpInside)
        containerView.addSubview(sumbitButton)
        sumbitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: -12, paddingBottom: 0, width: 50, height: 0)
      
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sumbitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        return containerView
    }()
    let commentTextField:UITextField = {
        let tx = UITextField()
        tx.placeholder = "Enter Comment"
        return tx
    }()
    
    
    @objc func handleSumbit() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("post.id",self.post?.id ?? "")
        print("Inserting Comment:",commentTextField.text ?? "")
        let postId = self.post?.id ?? ""
        let values = ["text":commentTextField.text ?? "",
        "creationDate":Date().timeIntervalSince1970,
        "uid":uid] as [String:Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Faild to insert comment",err)
                return
            }
            print("SuccessFully to comments")
        }
        
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
