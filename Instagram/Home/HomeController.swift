//
//  HomeController.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/30.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItem()
        fetchPosts()
    }
    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictinaries = snapshot.value as? [String:Any] else { return }
            dictinaries.forEach({ (key,value) in
                
                guard let dictionary = value as? [String:Any] else { return }
                let post =  Post(dictionary: dictionary)
                self.posts.append(post)
            })
            self.collectionView?.reloadData()
        }) { (err) in
            print("Faield to fetch to posts:",err)
        }
    }
    
    func setupNavigationItem() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
}
