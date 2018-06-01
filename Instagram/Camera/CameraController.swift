//
//  CameraController.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/06/01.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let dismissButon:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let caputurePhotoButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleCaputureButton), for: .touchUpInside)
        return btn
    }()
    @objc func handleCaputureButton() {
        print("Captuing photo....")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaputureSession()
        setupHUD()
    }
    func setupHUD() {
        view.addSubview(caputurePhotoButton)
        view.addSubview(dismissButon)
        caputurePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -24, width: 80, height: 80)
        caputurePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButon.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingRight: -12, paddingBottom: 0, width: 50, height: 50)
    }
   fileprivate func setupCaputureSession() {
        let caputureSession = AVCaptureSession()
    guard let caputureDevice = AVCaptureDevice.default(for: .video) else { return }
    do {
        let input = try AVCaptureDeviceInput(device:caputureDevice )
        if caputureSession.canAddInput(input) {
              caputureSession.addInput(input)
        }
    } catch let err {
        print("Could not setup camera input;",err)
    }
    let output = AVCapturePhotoOutput()
    if caputureSession.canAddOutput(output) {
         caputureSession.addOutput(output)
    }
    let previewLayer = AVCaptureVideoPreviewLayer(session: caputureSession)
    previewLayer.frame = view.frame
    view.layer.addSublayer(previewLayer)
    
    caputureSession.startRunning()
    }
}
