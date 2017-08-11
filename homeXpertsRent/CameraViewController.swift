//
//  CameraViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 08/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var photoConfirmationHandler: ((UIImage?) -> Void)?
    
    private var session: AVCaptureSession?
    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var previewView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
//        let orientation = UIDevice.current.orientation
//        
//        if UIDeviceOrientationIsPortrait(orientation) || UIDeviceOrientationIsLandscape(orientation) {
//            if let videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) {
//                videoPreviewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
//            }
//        }
//        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func initialize()
    {
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        do{
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print (error!.localizedDescription)
        }
        
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            
            if session!.canAddOutput(capturePhotoOutput) {
                session!.addOutput(capturePhotoOutput)
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(videoPreviewLayer!)
                session!.startRunning()
                
                videoPreviewLayer!.frame = previewView.bounds
            }
        }
    }
    
    @IBAction func buttonCancelPressed(_ sender: Any) {
        
        self.dismiss(animated: false, completion: {
            if self.photoConfirmationHandler != nil {
                self.photoConfirmationHandler!(nil)
            }
        })
        
    }

    
    @IBAction func buttonCapturePressed(_ sender: Any) {
        
        guard let capturePhotoOutput = self.capturePhotoOutput else {
            return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        let localImage = UIImage.init(data: imageData, scale: 1.0)
        
        if let image = localImage {
            
            let confirmPhotoView = storyboard?.instantiateViewController(withIdentifier: "ConfirmPhotoViewController") as! ConfirmPhotoViewController
            
            let viewController = self as CameraViewController
            confirmPhotoView.image = image
            
            confirmPhotoView.photoConfirmationHandler = { (confirm) in
                
                
                if self.photoConfirmationHandler != nil && confirm == true {
                    
                    self.session!.stopRunning()
                    viewController.dismiss(animated: true, completion: {
                        if self.photoConfirmationHandler != nil {
                            self.photoConfirmationHandler!(image)
                        }
                    })
                }
            }
            
            self.present(confirmPhotoView, animated: false, completion: nil)
        }
    }
    
}
