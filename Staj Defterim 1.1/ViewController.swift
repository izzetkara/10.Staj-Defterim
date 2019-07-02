//
//  ViewController.swift
//  Staj Defterim 1.1
//
//  Created by İzzet Kara on 2.07.2019.
//  Copyright © 2019 Izzet Kara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var defterimLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func addButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
}

