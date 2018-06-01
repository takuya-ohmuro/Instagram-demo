//
//  CameraController.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/06/01.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController,AVCapturePhotoCaptureDelegate {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaputureSession()
        setupHUD()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func setupHUD() {
        view.addSubview(caputurePhotoButton)
        view.addSubview(dismissButon)
        caputurePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -24, width: 80, height: 80)
        caputurePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButon.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingRight: -12, paddingBottom: 0, width: 50, height: 50)
    }
    @objc func handleCaputureButton() {
        print("Captuing photo....")
        let setting = AVCapturePhotoSettings()
       guard let previewFormatType = setting.availablePreviewPhotoPixelFormatTypes.first else { return }
        setting.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewFormatType]
        output.capturePhoto(with: setting, delegate: self)
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard let sample = photoSampleBuffer else { return }
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sample, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else { return }
        let previewImage = UIImage(data: imageData)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
//        let previewImageView = UIImageView(image: previewImage)
//        view.addSubview(previewImageView)
//        view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    
    let output = AVCapturePhotoOutput()
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
    
    if caputureSession.canAddOutput(output) {
         caputureSession.addOutput(output)
    }
    let previewLayer = AVCaptureVideoPreviewLayer(session: caputureSession)
    previewLayer.frame = view.frame
    view.layer.addSublayer(previewLayer)
    
    caputureSession.startRunning()
    }
}
