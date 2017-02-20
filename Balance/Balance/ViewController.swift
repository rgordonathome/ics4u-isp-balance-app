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
    var students : [Student] = []
    var timer : Timer = Timer()
    var currentSpeaker : Int = -1
    var totalTime : Int = 0
    var discussionActive : Bool = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonEndDiscussion: UIButton!
    @IBOutlet weak var buttonPauseDiscussion: UIButton!
    @IBOutlet weak var labelDiscussionStatus: UILabel!
    @IBOutlet weak var labelDiscussionDetail: UILabel!
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the list of students
        students.append(Student(name: "Bagga, Puneet"))
        students.append(Student(name: "Blackwell, Scott"))
        students.append(Student(name: "Byrne, Liam"))
        students.append(Student(name: "Elder, Andrew"))
        students.append(Student(name: "Goldsmith, Jeffrey"))
        students.append(Student(name: "Jones, Nicholas"))
        students.append(Student(name: "Leder, Brendan"))
        students.append(Student(name: "McCutcheon, Mark"))
        students.append(Student(name: "Noble Curveira, Carlos"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource protocol required methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Return the number of rows in the section
        return students.count

    }
    
    // Control the content of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Reuse cells while scrolling to maintain high performance
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // Configure the cell
        cell.textLabel?.text = students[indexPath.row].name
        cell.detailTextLabel?.text = students[indexPath.row].formattedTime
        
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
            
            // Start the timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.tick), userInfo: nil, repeats: true)
            
            // Enable the end discussion button
            buttonPauseDiscussion.isEnabled = true
            buttonEndDiscussion.isEnabled = true
            
            // Clear all the times for each student
            for (index, student) in students.enumerated() {
                student.seconds = 0
                updateTime(for: index)
            }
            
            // Update discussion status and detail
            totalTime = 0
            labelDiscussionStatus.text = "Active"
            labelDiscussionDetail.text = "0:00"
            discussionActive = true
                        
        } else {
            
            // Restarting a paused discussion
            buttonPauseDiscussion.isEnabled = true
            labelDiscussionStatus.text = "Active"
            updateTotalTime()
            discussionActive = true
        }
        
    }
    
    // Updates time tracking if the discussion is not paused or ended
    func tick() {
        
        if discussionActive {
            
            // Update the model
            students[currentSpeaker].seconds += 1
            
            // Track total discussion time
            totalTime += 1
            
            // Update the view
            updateTime(for: currentSpeaker)

        }
        
    }
    
    // Updates the time for the current speaker and discussion
    func updateTime(for speaker : Int) {

        // Get an indexPath for this speaker
        let nsIndexPath = NSIndexPath(row: speaker, section: 0)
        if let indexPath = nsIndexPath as? IndexPath {
            
            // Update the cell in the table with the new time
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = students[indexPath.row].name
                cell.detailTextLabel?.text = students[indexPath.row].formattedTime
            }
            
        }
        
        // Update the total time
        updateTotalTime()
    }

    // Update and format total time for discussion
    func updateTotalTime() {
        let minutes = String(totalTime / 60)
        let seconds = String(totalTime % 60)
        let paddedSeconds = String(repeating: "0", count: 2 - seconds.characters.count) + seconds
        let formattedTime = minutes + ":" + paddedSeconds
        labelDiscussionDetail.text = formattedTime
    }
    
    // MARK: Actions
    
    @IBAction func endDiscussion(_ sender: Any) {
        
        // Stop the current discussion by closing the timer
        timer.invalidate()
        buttonPauseDiscussion.isEnabled = false
        buttonEndDiscussion.isEnabled = false
        labelDiscussionStatus.text = "Complete"
        updateTotalTime()
        discussionActive = false
        
    }

    @IBAction func pauseDiscussion(_ sender: Any) {
        
        // Pause the discussion
        buttonPauseDiscussion.isEnabled = false
        discussionActive = false
        labelDiscussionStatus.text = "Paused"
        updateTotalTime()
    }

}

