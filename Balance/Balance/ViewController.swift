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
    var activeSpeakerListPosition : Int = 0
    var activeSpeakers = 0
    var totalTime : Int = 0
    var discussionActive : Bool = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonEndDiscussion: UIButton!
    @IBOutlet weak var buttonNewDiscussion: UIButton!
    @IBOutlet weak var labelDiscussionStatus: UILabel!
    @IBOutlet weak var buttonToggleDiscussion: UIButton!
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize student list
        resetStudents()
        
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
    func change(toSpeakerAt newSpeakerListPosition : Int) {
        
        // Change the current speaker
        students[activeSpeakerListPosition].isCurrentlyActiveSpeaker = false
        activeSpeakerListPosition = newSpeakerListPosition
        students[activeSpeakerListPosition].isCurrentlyActiveSpeaker = true
        
        // Start the timer if needed
        if !timer.isValid {
            
            // Start the timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.tick), userInfo: nil, repeats: true)
        }
        
        // Make the discussion active
        discussionActive = true
        buttonToggleDiscussion.isEnabled = true
        buttonEndDiscussion.isEnabled = true
        labelDiscussionStatus.isEnabled = true
        updateTotalTime()
        
    }
    
    // Updates time tracking if the discussion is not paused or ended
    @objc func tick() {
        
        if discussionActive {
            
            // Track number of active speakers
            if students[activeSpeakerListPosition].seconds == 0 {
                activeSpeakers += 1
            }
            
            // Update the model
            students[activeSpeakerListPosition].seconds += 1
            
            // Track total discussion time
            totalTime += 1
            
            // Sort the students by time
            sortStudents()
            
            // Update cell colour for all speakers
            updateStats()
            
            // Update the view for the speaker
            updateTime(for: activeSpeakerListPosition)
            
        }
        
    }
    
    // Sorts students by time speaking
    func sortStudents() {
        
        // Use newly updated time stats to sort the students in descending order
        let newlySortedStudentsList = students.sorted(by: {
            $0.seconds > $1.seconds
        })
        
        // Update color for this student
        updateColor(for: activeSpeakerListPosition)
        
        // Find the current speaker in the new array so that the updates to the table reflect new position
        for (newActiveSpeakerListPosition, student) in newlySortedStudentsList.enumerated() {
            
            if student.isCurrentlyActiveSpeaker == true {
                
                // See if the student's position has changed based on updated times
                if activeSpeakerListPosition != newActiveSpeakerListPosition {

                    // Get the old and new position of the student
                    let oldPosition = NSIndexPath(row: activeSpeakerListPosition, section: 0) as IndexPath
                    let newPosition = NSIndexPath(row: newActiveSpeakerListPosition, section: 0) as IndexPath

                    // Animate the movement of the student to their new position in the list
                    tableView.moveRow(at: oldPosition, to: newPosition)
                    
                }
                
                // Update the current speaker
                activeSpeakerListPosition = newActiveSpeakerListPosition
            }
        }
        
        // Save the newly sorted array
        // NOTE: No need to invoke tableView.reloadData since we took care of moving the student to new position in the tableView just above this section
        students = newlySortedStudentsList
        
    }
    
    // Reset the student list
    func resetStudents() {
        
        // Load the list of students
        students = []
        students.append(Student(name: "Bagga, Puneet", id: 1))
        students.append(Student(name: "Blackwell, Scott", id: 2))
        students.append(Student(name: "Byrne, Liam",  id: 3))
        students.append(Student(name: "Elder, Andrew", id: 4))
        students.append(Student(name: "Goldsmith, Jeffrey", id: 5))
        students.append(Student(name: "Jones, Nicholas", id: 6))
        students.append(Student(name: "Leder, Brendan", id: 7))
        students.append(Student(name: "McCutcheon, Mark", id: 8))
        students.append(Student(name: "Noble Curveira, Carlos", id: 9))
        
    }
    
    // Updates the times for all students
    func updateStats() {
        
        // Get the average time per student
        let averageSpeakingTime = Float(totalTime) / Float(activeSpeakers)
        
        // Update the colour for each student
        for (index, student) in students.enumerated() {
            
            // Get this student's hue
            if student.seconds > 0 {
                var percentOfAverage = Float(student.seconds) / averageSpeakingTime
                // DEBUG: print("Percent of average for student \(index) is \(percentOfAverage)")
                if percentOfAverage <= 1 {
                    // Calculate hue as percentage of ideal (120 degrees is green)
                    student.hue = 120 * percentOfAverage
                } else {
                    // Count how far above average this person is
                    percentOfAverage -= 1
                    // Move back toward red (student is above average participant
                    student.hue = 120 - 120 * percentOfAverage
                }
                // Make sure student can go no worse than pure red
                if student.hue < 0 {
                    student.hue = 0
                }
            }
            
            // Update color for this student
            updateColor(for: index)
            
        }
        
        
    }
    
    // Updates the background colour for a speaker
    func updateColor(for speaker : Int, saturation : Float = 0.75) {
        
        // Get an indexPath for this speaker
        let indexPath = NSIndexPath(row: speaker, section: 0) as IndexPath
        
        // Update cell colour if student has been active
        if students[speaker].seconds > 0 {
            
            // Update the cell in the table with the new color
            if let cell = tableView.cellForRow(at: indexPath) {
                
                // Calculate the hue
                let hue = CGFloat(students[speaker].hue)/360
                
                // Change colour when cell is not the currently selected cell
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.5)
                cell.backgroundColor = UIColor(hue: hue, saturation: CGFloat(saturation), brightness: 1/100*90, alpha: 1/100*100)
                UIView.commitAnimations()
                
                // Change colour when cell IS the currently selected cell
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.5)
                cell.selectedBackgroundView?.layer.backgroundColor = UIColor(hue: hue, saturation: CGFloat(saturation), brightness: 1/100*90, alpha: 1/100*100).cgColor
                UIView.commitAnimations()
            }
            
        } else {
            
            // Update the cell in the table with default color
            if let cell = tableView.cellForRow(at: indexPath) {
                
                // Change colour when cell is not the currently selected cell
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.5)
                cell.backgroundColor = UIColor.white
                UIView.commitAnimations()
                
                // Change colour when cell IS the currently selected cell
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.5)
                cell.selectedBackgroundView?.layer.backgroundColor = UIColor.white.cgColor
                UIView.commitAnimations()
            }
            
            
        }
    }
    
    // Resets the background colours
    func resetColors(for speaker : Int) {
        
        // Get an indexPath for this speaker
        let indexPath = NSIndexPath(row: speaker, section: 0) as IndexPath
        // Update the cell in the table with the new color
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = UIColor.white
            cell.selectionStyle = UITableViewCell.SelectionStyle.default
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.lightGray
            cell.selectedBackgroundView = bgColorView
        }
        
    }
    
    
    // Updates the time for the current speaker and discussion
    func updateTime(for speaker : Int) {
        
        // Get an indexPath for this speaker
        let indexPath = NSIndexPath(row: speaker, section: 0) as IndexPath
        
        // Update the cell in the table with the new time
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.textLabel?.text = students[indexPath.row].name
            cell.detailTextLabel?.text = students[indexPath.row].formattedTime
        }
        
        // Update the total time
        updateTotalTime()
    }
    
    // Makes a given speaker active or inactive
    func make(speaker : Int, active : Bool) {
        
        let indexPath = NSIndexPath(row: speaker, section: 0) as IndexPath
        
        // Update the cell in the table with the new time
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if active {
                cell.textLabel?.isEnabled = true
                cell.detailTextLabel?.isEnabled = true
            } else {
                cell.textLabel?.isEnabled = false
                cell.detailTextLabel?.isEnabled = false
            }
            
        }
        
    }
    
    // Update and format total time for discussion
    func updateTotalTime() {
        let minutes = String(totalTime / 60)
        let seconds = String(totalTime % 60)
        let paddedSeconds = String(repeating: "0", count: 2 - seconds.count) + seconds
        let formattedTime = minutes + ":" + paddedSeconds
        labelDiscussionStatus.text = formattedTime
    }
    
    // MARK: Actions
    
    @IBAction func startDiscussion(_ sender: Any) {
        
        // Allow a discussion to be tracked
        buttonNewDiscussion.isEnabled = false
        tableView.isUserInteractionEnabled = true
        
        // Clear all the times for each student
        resetStudents()
        tableView.reloadData()
        for (index, _) in students.enumerated() {
            updateTime(for: index)
            make(speaker: index, active: true)
            resetColors(for: index)
        }
        
        // Update discussion status and detail
        totalTime = 0
        activeSpeakers = 0
        activeSpeakerListPosition = 0
        labelDiscussionStatus.text = "0:00"
        
    }
    @IBAction func endDiscussion(_ sender: Any) {
        
        // Stop the current discussion by closing the timer
        timer.invalidate()
        labelDiscussionStatus.isEnabled = false
        UIView.setAnimationsEnabled(false)
        buttonToggleDiscussion.setTitle("❙❙", for: UIControl.State.normal)
        buttonToggleDiscussion.titleLabel?.font = UIFont(name: "Zapf Dingbats", size: 30.0)
        buttonToggleDiscussion.setNeedsDisplay()
        UIView.setAnimationsEnabled(true)
        buttonToggleDiscussion.isEnabled = false
        buttonEndDiscussion.isEnabled = false
        buttonNewDiscussion.isEnabled = true
        updateTotalTime()
        tableView.isUserInteractionEnabled = false
        discussionActive = false
        for (index, _) in students.enumerated() {
            make(speaker: index, active: true)
            updateColor(for: index, saturation: 0.3)
        }
        
        // De-select the last speaker in the conversation (so it doesn't carry over to new discussion)
        let indexPath = NSIndexPath(row: activeSpeakerListPosition, section: 0) as IndexPath
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    @IBAction func toggleDiscussionState(_ sender: Any) {
        
        if discussionActive {
            // Pause the currently active discussion
            UIView.setAnimationsEnabled(false)
            buttonToggleDiscussion.titleLabel?.font = UIFont(name: "Zapf Dingbats", size: 26.0)
            buttonToggleDiscussion.setTitle("▶︎", for: UIControl.State.normal)
            buttonToggleDiscussion.setNeedsDisplay()
            UIView.setAnimationsEnabled(true)
            discussionActive = false
            updateTotalTime()
            labelDiscussionStatus.isEnabled = false
            tableView.isUserInteractionEnabled = false
            for (index, _) in students.enumerated() {
                make(speaker: index, active: true)
                updateColor(for: index, saturation: 0.3)
            }
        } else {
            // Re-enable the currently active discussion
            UIView.setAnimationsEnabled(false)
            buttonToggleDiscussion.setTitle("❙❙", for: UIControl.State.normal)
            buttonToggleDiscussion.titleLabel?.font = UIFont(name: "Zapf Dingbats", size: 30.0)
            buttonToggleDiscussion.setNeedsDisplay()
            UIView.setAnimationsEnabled(true)
            tableView.isUserInteractionEnabled = true
            
            for (index, _) in students.enumerated() {
                make(speaker: index, active: true)
                updateColor(for: index, saturation: 0.5)
            }
            buttonToggleDiscussion.isEnabled = false
            
        }
        
    }
    
}

