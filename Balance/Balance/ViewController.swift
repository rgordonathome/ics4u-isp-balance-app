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
    var timer : Timer = Timer()
    var currentSpeaker : Int = -1
    @IBOutlet weak var tableView: UITableView!
    
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
    
    // When a student is tapped, manage time tracking
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Change current speaker to selected row
        change(toSpeakerAt: indexPath.row)
        
    }
    
    // MARK: Balance logic
    
    // Switches the current speaker
    func change(toSpeakerAt newSpeaker : Int) {
        
        // Change the current speaker
        currentSpeaker = newSpeaker
        
        // Start the timer if needed
        if !timer.isValid {
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.tick), userInfo: nil, repeats: true)
            
        }
        
    }
    
    // Updates time tracking
    func tick() {
                
        // Update the model
        studentNames[currentSpeaker].seconds += 1
        
        // Get an indexPath for current speaker
        let nsIndexPath = NSIndexPath(row: currentSpeaker, section: 0)
        if let indexPath = nsIndexPath as? IndexPath {

            // Update the cell in the table with the new time
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = studentNames[indexPath.row].name
                cell.detailTextLabel?.text = studentNames[indexPath.row].formattedTime
            }

        }
        
        
    }


}

