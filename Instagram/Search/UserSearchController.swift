//
//  UserSearchController.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/31.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    lazy var searchBar:UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        }else{
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.userName.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: -8, paddingBottom: 0, width: 0, height: 0)
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.alwaysBounceVertical = true
        
        fetchUsers()
    }
    var filteredUsers = [User]()
    var users = [User]()
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else { return }
            dictionaries.forEach({ (key,value) in
                guard let userDictionary = value as? [String:Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.userName.compare(u2.userName) == .orderedAscending
            })
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        }) { (err) in
            print("Faild to fetch users for search:",err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}
