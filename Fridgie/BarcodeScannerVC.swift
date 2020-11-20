//
//  BarcodeScannerVC.swift
//  Fridgie
//
//  Created by Julian Silvestri on 2020-11-19.
//

import UIKit
import UIKit
import AVFoundation


class BarcodeScannerVC: UIViewController {
    
    let torchButton = UIButton()
    let finishedButton = UIButton()
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var scanRectView: UIView?
    var labelType = ""
    var row = 0
    var shape = CAShapeLayer()
    var shape1 = CAShapeLayer()
    var shape2 = CAShapeLayer()
    var captureDevice: AVCaptureDevice?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]

    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession.beginConfiguration()
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: torchButton)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Camera does not work in emulator mode")
            return
        }
        
        do {
            qrCodeFrameView = UIView()
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            let cancelBtn = UIButton()
            cancelBtn.frame = CGRect(x: 100, y: 100, width: 90, height: 60)
            cancelBtn.layer.cornerRadius = 12
            //cancelBtn.backgroundColor = hexStringToUIColor(hex: "#00bcc8")
            cancelBtn.setTitle("Cancel", for: .normal)
            cancelBtn.setTitleColor(UIColor.white, for: .normal)
            cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            self.view.addSubview(cancelBtn)
            self.view.bringSubviewToFront(cancelBtn)
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    
    //MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        torchButton.frame = CGRect(x: (self.view.frame.size.width - 80), y: 15, width: 100, height: 50)
        finishedButton.frame = CGRect(x: (self.view.frame.size.width) - 1150, y: 30, width: 100, height: 50)
    }
    
    //MARK: Cancel Action
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Launch App
    func launchApp(barcodeScan: String) {
        guard presentedViewController == nil else {
            return
        }
        
//        let purolator = barcodeScan.substring(with: 11..<23)
//        let fedex = barcodeScan.substring(with: 22..<34)
//        var fed = ""
//        var pur = ""
//        pur.append("\(purolator)")
//        fed.append("\(fedex)")
        print(barcodeScan)
        
    }
    
    //MARK: Torch Button
    @objc func torchButtonAction(_ sender: UIBarButtonItem) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
                torchButton.titleLabel?.font = UIFont(name:"Font Awesome 5 Pro", size: 25)
                torchButton.setTitle("", for: .normal)
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    torchButton.titleLabel?.font = UIFont(name:"Font Awesome 5 Pro", size: 25)
                    torchButton.setTitle("", for: .normal)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    deinit {
        print("deinit barcode scanner vc")
    }
    
}
//MARK: Extension
extension BarcodeScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }

        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(barcodeScan: metadataObj.stringValue!)
                return
            }
        }
    }
    
    //MARK: Update Preview Layer
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = view.layer.bounds
    }
    
    //MARK: View Did Layout Subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection = self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection

            if previewLayerConnection.isVideoOrientationSupported {
                switch (orientation) {
                case .portrait:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                    
                case .landscapeRight:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                    break
                    
                case .landscapeLeft:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                    break
                    
                case .portraitUpsideDown:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    //MARK: Hex String To UI Color
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

//    func substring(from: Int) -> String {
//        let fromIndex = index(from: from)
//        return String(self[fromIndex...])
//    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

