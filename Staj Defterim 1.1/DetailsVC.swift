//
//  DetailsVC.swift
//  Staj Defterim 1.1
//
//  Created by İzzet Kara on 2.07.2019.
//  Copyright © 2019 Izzet Kara. All rights reserved.
//

import UIKit
import CoreData
class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var countDay: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var paragraphText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailsVC.selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
//Fotografi secmek
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }

//Fotografi sectikten sonra geri donmek icin.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
 // kaydetme butonu
    @IBAction func saveClicked(_ sender: Any) {
        //appdelegate ulasmak icin
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Bundan once import coredata yi eklemeyi unutma
        let newStajDefterim = NSEntityDescription.insertNewObject(forEntityName: "StajDefterim", into: context)
        
    //attributes
        
        newStajDefterim.setValue(countDay.text, forKey: "countDay")
        newStajDefterim.setValue(paragraphText, forKey: "paragraph")
        newStajDefterim.setValue(titleText, forKey: "title")
        //Date icin bunun dogru olduguna emin degilim.
        newStajDefterim.setValue(dateText.text, forKey: "date")
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        newStajDefterim.setValue(data, forKey: "image")
        
        
        do {
            try context.save()
            print("No ERROR!")
        } catch  {
            print("ERROR!")
        }
        
    }
    
    

}
