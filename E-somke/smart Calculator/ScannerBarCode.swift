//
//  ScannerBarCode.swift
//  E-somke
//
//  Created by Piotr Żakieta on 31/03/2019.
//  Copyright © 2019 Piotr Żakieta. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var barcode: String?
    var delegate: IsbnDelegate?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStyle()
        mainView.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = mainView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        mainView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        barcode = code
        loadStyle()
        if let sku = barcode{
            skuLabel.text = sku
        }else{
                
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func endOrSend(_ sender: Any) {//przycisk odpowiedialny za zakonczenie lub przesłanie zdarzenia dalej :D
        if let sku = barcode{
            self.delegate?.passData(isbn: sku)
        }
        
        //self.delegate?.passData(isbn: "123")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func refreshScaner(_ sender: Any) {
        barcode = nil
        captureSession.startRunning()
        loadStyle()
        
    }
    
    func loadStyle() {
        
        mainButton.layer.cornerRadius = 12
        navigationController?.isNavigationBarHidden = true //ukrywanie navibar
        
        refreshButton.layer.backgroundColor = UIColor.black.cgColor
        refreshButton.alpha = 0.5
        refreshButton.layer.cornerRadius = 25
        
        if let _ = barcode{
            mainButton.layer.backgroundColor = UIColor(red:0.00, green:0.63, blue:0.03, alpha:1.0).cgColor
            mainButton.setTitle("Zatwierdź", for: .normal)
            
            skuLabel.isHidden = false
            skuLabel.layer.backgroundColor = UIColor.black.cgColor
            skuLabel.textColor = UIColor.white
            skuLabel.layer.cornerRadius = 8
            skuLabel.alpha = 0.5
            refreshButton.isHidden = false
        } else {
            mainButton.layer.backgroundColor = UIColor(red:0.81, green:0.00, blue:0.00, alpha:1.0).cgColor
            mainButton.setTitle("Powrót", for: .normal)
            skuLabel.isHidden = true
            refreshButton.isHidden = true
        }
    }
    
}
