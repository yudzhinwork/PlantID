//
//  ScannerViewController.swift
//  PlantID

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var cameraView: UIView!
    private var photoOutput: AVCapturePhotoOutput!
    
    private var scannerType: ScannerType = .identify
    private var isFlashOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startCameraSession()
        setupCameraView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let preScannerViewController = ScannerFirstViewController()
        preScannerViewController.delegate = self
        preScannerViewController.modalPresentationStyle = .overCurrentContext
        preScannerViewController.modalTransitionStyle = .crossDissolve
        self.present(preScannerViewController, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the camera view and preview layer frames
        cameraView.frame = view.bounds
        previewLayer.frame = cameraView.bounds
    }
    
    private func setupCameraView() {
        cameraView = UIView(frame: view.bounds)
        cameraView.backgroundColor = .black
        view.addSubview(cameraView)
        
        // Configure the preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        view.sendSubviewToBack(cameraView)
    }
    
    private func startCameraSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("No camera available")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch {
            print("Error setting up camera input: \(error)")
            return
        }
        
        photoOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.startRunning()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }

    @IBAction func flashAction(_ sender: UIButton) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
             print("Torch is not available.")
             return
         }
         
         do {
             try device.lockForConfiguration()
             
             if isFlashOn {
                 device.torchMode = .off
                 isFlashOn = false
             } else {
                 try device.setTorchModeOn(level: 1.0)
                 isFlashOn = true
             }
             
             device.unlockForConfiguration()
         } catch {
             print("Error accessing the torch: \(error)")
         }
    }

    @IBAction func mediaAction(_ sender: UIButton) {
        
    }

    @IBAction func photoAction(_ sender: UIButton) {
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
         if let error = error {
             print("Error capturing photo: \(error.localizedDescription)")
             return
         }
         
         guard let imageData = photo.fileDataRepresentation(),
               let image = UIImage(data: imageData) else {
             print("Failed to create image from photo data")
             return
         }
        
        let vc = ScannerScanningViewController()
        vc.scannerType = scannerType
        vc.scanningImage = image
        self.navigationController?.pushViewController(vc, animated: true)
     }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available on this device.")
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let vc = ScannerScanningViewController()
                vc.scannerType = scannerType
                vc.scanningImage = image
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        picker.dismiss(animated: true)
    }

}

extension ScannerViewController: ScannerFirstViewControllerDelegate {
    
    func scannerFirstViewController(_ controller: ScannerFirstViewController, scannerType type: Int) {
        let type = ScannerType(rawValue: type)!
        scannerType = type
    }
}
