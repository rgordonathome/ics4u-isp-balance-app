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
    var studentNames : [Student] = []
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the list of students
        studentNames.append(Student(name: "Bagga, Puneet", seconds: 0))
        studentNames.append(Student(name: "Blackwell, Scott", seconds: 0))
        studentNames.append(Student(name: "Byrne, Liam", seconds: 0))
        studentNames.append(Student(name: "Elder, Andrew", seconds: 0))
        studentNames.append(Student(name: "Goldsmith, Jeffrey", seconds: 0))
        studentNames.append(Student(name: "Jones, Nicholas", seconds: 0))
        studentNames.append(Student(name: "Leder, Brendan", seconds: 0))
        studentNames.append(Student(name: "McCutcheon, Mark", seconds: 0))
        studentNames.append(Student(name: "Noble Curveira, Carlos", seconds: 0))
        
        
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
        cell.textLabel?.text = studentNames[indexPath.row].name
        cell.detailTextLabel?.text = studentNames[indexPath.row].formattedTime
        
        // Return the cell for use in the table view
        return cell
    }


}

