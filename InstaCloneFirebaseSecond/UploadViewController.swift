//
//  UploadViewController.swift
//  InstaCloneFirebaseSecond
//
//  Created by Islam Rzayev on 12.03.24.
//

import UIKit
import Photos
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

//PHPicker Method

class UploadViewController: UIViewController, PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
           
           for result in results {
              result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                 if let image = object as? UIImage {
                    DispatchQueue.main.async {
                       // Use UIImage
                       print("Selected image: \(image)")
                        self.addImageView.image = image
                    }
                 }
              })
           }
    }
    
   
    
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        addImageView.image = UIImage(named: "upload")

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        addImageView.isUserInteractionEnabled = true

        addImageView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    
    @objc func chooseImage(){
        
        //PHPicker Method
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 1
//        config.filter = PHPickerFilter.images
//
//        let pickerViewController = PHPickerViewController(configuration: config)
//        pickerViewController.delegate = self
//        self.present(pickerViewController, animated: true, completion: nil)
//        
//    }
//    
    
    
    
    
    
    //    @objc func chooseImage(){
    //        let pickerController = UIImagePickerController()
    //        pickerController.delegate = self
    //        pickerController.sourceType = .
    //    }
    
    func makeAlert(inputText: String, inputMessage: String){
        let alert = UIAlertController(title: inputText, message: inputMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
   
    @IBAction func shareClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        let uuid = UUID().uuidString

        
        if let data = addImageView.image?.jpegData(compressionQuality: 0.5){
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metaData, error) in
                if error != nil{
                    
                    self.makeAlert(inputText:"Error!", inputMessage: error?.localizedDescription ?? "Error")

                }else{
                    imageReference.downloadURL { (url, error) in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            
                            
                            //Database

                            let firestoreDatabase =  Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl, "postedBy" : Auth.auth().currentUser?.email, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as? [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost!, completion: { (error) in
                                
                                if error != nil{
                                    self.makeAlert(inputText: "Error", inputMessage: error?.localizedDescription ?? "Error")
                                }else{
                                    self.addImageView.image = UIImage(named: "upload")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex =  0
                                }
                                
                            })
                            
                            
                            
                        }
                    }
                }
            }
        }
    }
    
}
