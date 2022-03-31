//
//  addPhotoViewController.swift
//  MyPhotosLibrary
//
//  Created by Murat Sağlam on 16.03.2022.

import UIKit
import CoreData

class addPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedItem : Entity? = nil
    
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtDescription: UITextField!
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if selectedItem == nil {
            //yeni bir fotoğraf eklenecek
            self.navigationItem.title = "Add a New Photo"
            
        } else {
            // var olan bir fotoğraf düzenlenecek
            self.navigationItem.title = selectedItem?.titletext
            txtTitle.text = selectedItem?.titletext
            txtDescription.text = selectedItem?.descriptiontext
            imgPhoto.image = UIImage(data: (selectedItem?.image as! Data))
            btnSave.setTitle("Update", for: UIControl.State.normal)
            
        }
        
        
        
    }
    
    
    @IBAction func btnCameraClicked(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgPhoto.image = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnGalleryClicked(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        
        if selectedItem == nil {
            let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: pc)
            let newItem = Entity(entity: entityDescription!, insertInto: pc)
            newItem.titletext = txtTitle.text
            newItem.descriptiontext = txtDescription.text
            newItem.image = imgPhoto.image!.jpegData(compressionQuality: 0.8) as NSData?
        } else {
            
            selectedItem?.titletext = txtTitle.text
            selectedItem?.descriptiontext = txtDescription.text
            selectedItem?.image = imgPhoto.image!.jpegData(compressionQuality: 0.8) as NSData?
        }
        
        do {
            
            if pc.hasChanges {
                try pc.save()
            }
            
        } catch {
            print(error)
            return
        }
        navigationController!.popViewController(animated: true)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        self.resignFirstResponder()
    }
    
    
}
