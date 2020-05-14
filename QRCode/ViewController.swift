//
//  ViewController.swift
//  QRCode
//
//  Created by RUPAM LAHA on 15/05/20.
//  Copyright © 2020 RUPAM LAHA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isHidden = true
        clearButton.isHidden = true
        saveButton.isHidden = true
        textField.delegate = self
        
    }

    @IBAction func generateTapped(_ sender: Any) {
        if textField.hasText == false{
            let alert = UIAlertController(title: "Opps!", message: "Type something to generate code", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else if (textField.text?.hasPrefix(" "))! || (textField.text?.hasSuffix(" "))! {
            let alert = UIAlertController(title: "Opps!", message: "The prefix and suffix should not have any spaces.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else if let qrString = textField.text {
            let data = qrString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
//            let filter = CIFilter(name: "CIPDF417BarCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 100, y: 100)
            
            let img = UIImage(ciImage: (filter?.outputImage?.transformed(by: transform))!)
            
            qrCode.image = img
            
            shareButton.isHidden = false
            clearButton.isHidden = false
            saveButton.isHidden = false
        }
        
        textField.resignFirstResponder()
        
    }
     
    @IBAction func shareTapped(_ sender: Any) {
        
        let share = UIActivityViewController(activityItems: [qrCode.image!], applicationActivities: nil)
        share.popoverPresentationController?.sourceView = self.view
        self.present(share, animated: true, completion: nil)
        
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        
        qrCode.image = nil
        clearButton.isHidden = true
        shareButton.isHidden = true
        saveButton.isHidden = true
        textField.text = ""
    }
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let guardImg = qrCode.image else{return}
        
        UIImageWriteToSavedPhotosAlbum(guardImg, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            let al = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(al, animated: true, completion: nil)
        }
        else{
            let al = UIAlertController(title: "Success!", message: "Successfully saved to photo gallery.", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(al, animated: true, completion: nil)
        }
    }
}

