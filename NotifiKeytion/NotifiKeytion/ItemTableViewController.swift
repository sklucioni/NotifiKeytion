//
//  ItemTableViewController.swift
//  NotifiKeytion
//
//  Created by Sarah Lucioni on 12/1/17.
//  Copyright © 2017 Sarah Lucioni. All rights reserved.
//
//  Apple Foodtracker tutorial helped with table view, navigation, edit/delete, and persisting data (https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/)
//

import UIKit
import os.log
import UserNotifications
import MapKit
import CoreLocation

class ItemTableViewController: UITableViewController {

    //MARK: Properties
    @IBOutlet var howToUseView: UIView!
    @IBOutlet weak var popupText: UILabel!
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background image
        //self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        // Round the corners of the popup view
        howToUseView.layer.cornerRadius = 5
        
        // Change popup text font
        popupText.font = UIFont(name: "Helvetica Neue Light", size: 20)
        
        // Load the sample data.
        //loadSampleItems()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved items
        if let savedItems = loadItems() {
            items += savedItems
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Set navigation bar back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        // Ask user to allow push notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Have as many rows as there are saved items
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // Sets up the view (individual cell) for each row of the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ItemTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        
        // Fetches the appropriate item for the data source layout.
        let item = items[indexPath.row]

        cell.nameLabel.text = item.name
        cell.photoImageView.image = item.photo
        
        // Cell background image
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        return cell
    }
    

   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Ability to remove items and edit the items displayed in the table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            
            saveItems()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new item.", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
                guard let itemDetailViewController = segue.destination as? ItemViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedItemCell = sender as? ItemTableViewCell else {
                    fatalError("Unexpected sender: \(sender ?? "")")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedItem = items[indexPath.row]
                itemDetailViewController.item = selectedItem
            
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
            }
    }
 
    
    
    //MARK: Actions
    
    // Animation for popup, make it appear larger, then shrink to actual size
    func animateInPopup () {
        self.view.addSubview(howToUseView)
        howToUseView.center = self.view.center
        
        // Make popup slightly bigger so that animation appears more
        howToUseView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        howToUseView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.howToUseView.alpha = 1
            self.howToUseView.transform = CGAffineTransform.identity
        }
    }
    
    // Animate popup to disappear
    func animateOutPopup () {
        UIView.animate(withDuration: 0.3, animations: {
            self.howToUseView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.howToUseView.alpha = 0
        }) {(success:Bool) in
            self.howToUseView.removeFromSuperview()
        }
    }
    
    // Show how to use popup when this button is clicked
    @IBAction func howToUseButton(_ sender: Any) {
        animateInPopup()
    }
    
    // Dismiss popup once this button is clicked
    @IBAction func dismissPopup(_ sender: Any) {
        animateOutPopup()
    }
    
    // Update table view after adding new items or editing items
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ItemViewController, let item = sourceViewController.item {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing item.
                items[selectedIndexPath.row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new item.
                let newIndexPath = IndexPath(row: items.count, section: 0)
                items.append(item)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the items.
            saveItems()
        }
    }
    
    //MARK: Private Methods
    
    /*private func loadSampleItems() {
        
        let photo1 = UIImage(named: "key")
        
     guard let item1 = Item(name: "Dorm Key", photo: photo1, rowNum: rowNum) else {
            fatalError("Unable to instantiate item1")
        }
        
        items += [item1]
    }*/
    
    // Save the items in an array
    private func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: Item.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Items successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save items...", log: OSLog.default, type: .error)
        }
    }
    
    // Load saved items
    private func loadItems() -> [Item]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
}
