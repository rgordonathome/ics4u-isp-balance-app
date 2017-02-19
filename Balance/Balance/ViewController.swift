//
//  ViewController.swift
//  Balance
//
//  Created by Russell Gordon on 2/9/17.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    var studentNames = ["Bagga, Puneet", "Blackwell, Scott", "Byrne, Liam", "Elder, Andrew", "Goldsmith, Jeffrey", "Jones, Nicholas", "Leder, Brendan", "McCutcheon, Mark", "Noble Curveira, Carlos"]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource protocol required methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Return the number of rows in the section
        return studentNames.count

    }
    
    // Control the content of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Reuse cells while scrolling to maintain high performance
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // Configure the cell
        cell.textLabel?.text = studentNames[indexPath.row]
        cell.detailTextLabel?.text = "0:00" // Placeholder for now
        
        // Return the cell for use in the table view
        return cell
    }


}

