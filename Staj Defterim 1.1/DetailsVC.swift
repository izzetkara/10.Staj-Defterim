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
    
    var chosenPicture = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if chosenPicture != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StajDefterim")
            fetchRequest.predicate = NSPredicate(format: "countDay= %@", self.chosenPicture)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        countDay.text = self.chosenPicture
                        
                        if let title = result.value(forKey: "title") as? String {
                            titleText.text = title
                        }
                        
                        if let paragraph = result.value(forKey: "paragraph") as? String {
                            paragraphText.text = paragraph
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            self.imageView.image = image
                        }
                        
                    }
                }
            } catch {
                
            }
            
            
        }
        
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailsVC.selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        print(chosenPicture)
        
        
        
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
        newStajDefterim.setValue(paragraphText.text, forKey: "paragraph")
        newStajDefterim.setValue(titleText.text, forKey: "title")
        //Date icin bunun dogru olduguna emin degilim.
        /*newStajDefterim.setValue(dateText.text, forKey: NSDate) */
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        newStajDefterim.setValue(data, forKey: "image")
        
        
        do {
            try context.save()
            print("No ERROR!")
        } catch  {
            print("ERROR!")
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name("newPicture"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    

}
