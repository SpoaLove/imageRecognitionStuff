//
//  ViewController.swift
//  imageRec
//
//  Created by Tengoku no Spoa on 2018/5/8.
//  Copyright © 2018年 Tengoku no Spoa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    let model = MobileNet()
    let picker = UIImagePickerController()
    let resulution = 224

    
    @IBAction func selectPhotoButtonDidPressed(_ sender: UIButton) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func takePhotoButtonDidPressed(_ sender: UIButton) {
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func analyzeImage(_ image:CVPixelBuffer) -> (String,Double) {
        do {
            let classType = try model.prediction(image: image).classLabel
            let percentage = try model.prediction(image: image).classLabelProbs[classType]
            return (classType,percentage!)
        } catch {
            return ("Undefined",0.0)
        }
    }
    
    func resizeImage(_ input:UIImage) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: resulution, height: resulution))
        input.draw(in: CGRect(x: 0, y: 0, width: resulution, height: resulution))
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let image = info["UIImagePickerControllerEditedImage"] as? UIImage else {return}
        let resizedImage = resizeImage(image)
        guard let pixelBuffer = resizedImage.toPixelBuffer() else {return}
        photoImageView.image = image
        let analysis = analyzeImage(pixelBuffer)
        resultLabel.text = analysis.0
        percentageLabel.text = "\(analysis.1 * 100)%"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.allowsEditing = true
    }
    
    
}
