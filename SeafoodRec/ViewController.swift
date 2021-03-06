//
//  ViewController.swift
//  SeafoodRec
//
//  Created by Babak Farahanchi on 2018-02-21.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = userPickedimage
            guard let ciimage = CIImage(image: userPickedimage) else{fatalError("could not handle CIImage for bob! ")}
            
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func detect(image:CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{fatalError("Loading coreMl model for inceptionv3 failed")}
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{fatalError("model failed to process image")}

//            if let firstResult = results.first {
//                if firstResult.identifier.contains("hotdog"){
//                    self.navigationItem.title = "Hotdog!!"
//                }else{
//                    self.navigationItem.title = "Not Hotdog!!!"
//                }
//
//            }
        print(results)
        
        
        
        
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])

        }catch{
            print(error)
        }
    
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    


}

