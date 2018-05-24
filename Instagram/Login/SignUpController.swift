
import UIKit
import Firebase
import FirebaseAuth

class SignUpController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let plusPhotoButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isEmailVaild = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isEmailVaild {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 244)
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let usernameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "UserName"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitleColor(.white, for:  .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSighUp), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    
    @objc func handleSighUp() {
        guard let email = emailTextField.text ,email.count>0 else { return }
        guard let username = usernameTextField.text,username.count>0 else { return }
        guard let password = passwordTextField.text,password.count>0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: FirebaseAuth.User?, error: Error?) in
            if let err = error {
                print("Faild to Create user:",err)
                return
            }
            print("Successfully created user:",user?.uid ?? "")
            
            guard let profileImage = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(profileImage, 0.5) else { return }
            
            let storageRef = Storage.storage().reference()
            guard let userImageUrl = user?.uid else { return }
            let storageRefChild = storageRef.child("user_profile_pictures/\(userImageUrl).jpg")
            storageRefChild.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Unable to upload image into storage due to: \(err)")
                }
                
                storageRefChild.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Unable to retrieve URL due to error: \(err.localizedDescription)")
                        return
                    }
                    let profileImageUrl =  url?.absoluteString
                    print("Profile Image successfully uploaded into storage with url: \(profileImageUrl ?? "" )")
                    guard let uid = user?.uid else { return }
                    let dictionaryValues = ["username":username,"profileImageUrl":profileImageUrl]
                    let values = [uid:dictionaryValues]
                    Database.database().reference().child("users").updateChildValues(values,withCompletionBlock:{ (err,ref) in
                        if let err = err {
                            print("Faild to save user info:",err)
                            return
                        }
                        print("Successfuly saved user info to do:",ref)
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        
                        mainTabBarController.setupViewControllers()
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                })
            })
        }
    }
    let alreadyHavaAccountButton:UIButton = {
        let button = UIButton(type: .system)
        
        let attributeText = NSMutableAttributedString(string: "Already hava an account?", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.lightGray])
        
        attributeText.append(NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributeText, for: .normal)
        
        button.setTitle("Don`t hava an account? Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    @objc func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(alreadyHavaAccountButton)
        alreadyHavaAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 50)
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupInField()
    }
    fileprivate func setupInField() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField,signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingRight: -40, paddingBottom: 0, width: 0, height: 200)
    }
}



