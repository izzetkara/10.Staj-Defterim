//
//  ViewController.swift
//  Staj Defterim 1.1
//
//  Created by İzzet Kara on 2.07.2019.
//  Copyright © 2019 Izzet Kara. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var defterimLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var countDayArray = [String]()
    /*var titleArray = [String]()*/
    var selectedPicture = ""
    /*var paragraphArray = [String]()
    var titleArray = [String]()
    var imageArray = [UIImage]()*/
    //sadece table view de countday gozuksun istedigim icin bunlari yazdirmiyorum.
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
        
        getInfo()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getInfo), name: NSNotification.Name(rawValue: "newPicture"), object: nil)
    }
    
    @objc func getInfo() {
        countDayArray.removeAll(keepingCapacity: true)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StajDefterim")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
            for result in results as! [NSManagedObject] {
                if let countDay =  result.value(forKey: "countDay") as? String {
                    self.countDayArray.append(countDay)
                }
                
                /*if let title = result.value(forKey: "title") as? String {
                    self.titleArray.append(title)
                }*/
                
                self.tableView.reloadData()
                
            }
        }
            
        } catch  {
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StajDefterim")
           
            
            do {
                let results = try context.fetch(fetchRequest)
                
             
                for result in results as! [NSManagedObject] {
                    if let countDay = result.value(forKey: "countDay") as? String {
                    if countDay == countDayArray[indexPath.row] {
                        context.delete(result)
                        countDayArray.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        
                        
                        do{
                            try context.save()
                        } catch {
                            
                        }
                        
                        break
                      }
                    }
                }
                
            } catch {
                
            }
            
        }
    }
   
    @IBAction func addButtonClick(_ sender: Any) {
        selectedPicture = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countDayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = countDayArray[indexPath.row]
        return cell
    }
    
    //tableview de birseye tiklandiginda onu cagirmak icin asagidaki kod:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
           let destinationVC = segue.destination as! DetailsVC
            
           destinationVC.chosenPicture = selectedPicture
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPicture = countDayArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    
    
}

