//
//  ItemViewController.swift
//  NotifiKeytion
//
//  Created by Sarah Lucioni on 11/30/17.
//  Copyright © 2017 Sarah Lucioni. All rights reserved.
//
//  Sources:
//      Popup (https://www.youtube.com/watch?v=CXvOS6hYADc)
//      Geofence (https://www.youtube.com/watch?v=0p7OPVXsMk0&t=2110s)
//      Dismisses Keyboard (https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift)
//      Ranging Beacons (https://www.youtube.com/watch?v=_4Qpf5WOBBI)
//      Notifications (https://www.youtube.com/watch?v=5TYKjt-2LMc)
//      Apple Foodtracker tutorial helped with table view, navigation, edit/delete, and persisting data (https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/)
//

import UIKit
// Allows messages to be sent to the console
import os.log
// Allows map access
import MapKit
// Allows current location access
import CoreLocation
// Allows notifications to be sent to user
import UserNotifications


class ItemViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UNUserNotificationCenterDelegate {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusInput: UITextField!
    @IBOutlet var howToPopup: UIView!
    @IBOutlet weak var popupText: UILabel!

    var regionRadius = 50
    var latitude:CLLocationDegrees = 0.0
    var longitude:CLLocationDegrees = 0.0
    var radius = 0.0
    var identifier = ""
    var beaconsToRange = [CLBeaconRegion]()
    var beacons = [CLBeacon]()

    // MARK: Map
    let manager:CLLocationManager = CLLocationManager()

    // Turn on background location services as long as user has always authorized location services
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // User has always authorized the use of their location
            manager.allowsBackgroundLocationUpdates = true
        }
    }

    // Access user location and set view for map in the item view
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.manager.stopUpdatingLocation()
        let location = locations[0]

        // How zoomed in on user location
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        // User location
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)

        // Show user location on the map
        self.mapView.showsUserLocation = true
    }

    // Add region to map with long tap (1.5 seconds long) and save values to the current item
    @IBAction func addRegion(_ sender: Any) {
        print("ADD REGION")
        guard let longPress = sender as? UILongPressGestureRecognizer else {return}
        let touchLocation = longPress.location(in: mapView)
        let centerCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        radius = CLLocationDistance(regionRadius)
        identifier = nameTextField.text!
        latitude = centerCoordinate.latitude
        longitude = centerCoordinate.longitude
        let region =  CLCircularRegion(center: centerCoordinate, radius: radius, identifier: identifier)
        mapView.removeOverlays(mapView.overlays)
        manager.startMonitoring(for: region)
        let circleRegion = MKCircle(center: centerCoordinate, radius: region.radius)
        mapView.add(circleRegion)
    }

    // Draw the region on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        //circleRenderer.strokeColor = .gray
        circleRenderer.fillColor = UIColor(red: 0, green: 0.4196, blue: 0.0627, alpha: 1.0)
        circleRenderer.alpha = 0.3
        return circleRenderer
    }

    /*func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            showAlert(title: "You left the \(identifier) region", message: "Finally!")
            rangeBeacons()
        }

        showAlert(title: "You entered the region", message: "Nice")
    }*/

    // Configure bluetooth beacon
    func rangeBeacons() {
        let proximityUUID = UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")
        let major:CLBeaconMajorValue = 10002
        let minor:CLBeaconMinorValue = 34452
        let beaconID = "com.example.myBeaconRegion"

        let beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID!, major: major, minor: minor, identifier: beaconID)

        // Start looking for signals from the registered bluetooth beacon
        manager.startRangingBeacons(in: beaconRegion)

        // If beacon is out of range (no beacons were found), send reminder notification
        if beacons.count == 0 {
            notify(title: "", body: "Did you forget your \(nameTextField.text!)?")
        }
    }

    // When User exits self defined region, check for beacons
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let identifier = region.identifier
        // Helper alert to tell developer that the exit region function is working
        showAlert(title: "You left the \(identifier) region", message: "Woohoo!")

        // Set up and check for beacon
        rangeBeacons()

        // Stop monitoring the current circular region because the desired response has already been triggered and the region is no longer needed
        manager.stopMonitoring(for: region)
    }

    // If rangeBeacon sends an error, send notification to user asking about item
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        notify(title: "", body: "Did you forget your \(nameTextField.text!)?")
        manager.stopRangingBeacons(in: region)
    }

    // If the beacon is found, test the proximity to one's phone to see if a notification needs to be sent
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let discoveredBeaconProximity = beacons.first?.proximity else {
            notify(title: "", body: "Did you forget your \(nameTextField.text!)?");
            return }

        let body:String = {

            if beacons.count > 0 {
                switch discoveredBeaconProximity {
                case .immediate: return ""
                case .near: return "Did you forget your \(nameTextField.text!)?"
                case .far: return "Did you forget your \(nameTextField.text!)?"
                case .unknown: return "Did you forget your \(nameTextField.text!)?"
                }
            } else {
                return "Did you forget your \(nameTextField.text!)?"
            }

        }()

        //showAlert(title: body, message: "beacon")
        if body != "" {
            notify(title: "", body: body)
        }

        // Stop looking for signals from the registered bluetooth beacon
        manager.stopRangingBeacons(in: region)
    }

    // Set up an in app alert to help developer and to send alerts to user if needed
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: Picker
    // Array of different types of items that will appear in the pickerView, a list of different items that can be tracked
    let types = ["key", "ID", "wallet", "purse", "other"]

    // Define default photo (of key) and corresponding row number (0) incase pickerView fails
    var photo = UIImage(named: "key")
    var rowNum = 0


    // Number of rows pickerView should display
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // What to list in pickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }

    // Number of rows to be displayed in pickerView (length of array)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }

    // When user picks a row, change photo value to corresponding photo and row number to corresponding value
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        photo = UIImage(named: types[row])
        rowNum = row
    }

    /*
     This value is either passed by `ItemTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new item.
     */
    var item: Item?

    // This function is called once the ItemViewController view has been loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Round the corners of the popup view
        howToPopup.layer.cornerRadius = 5

        // Change popup text font
        popupText.font = UIFont(name: "Helvetica Neue Light", size: 20)

        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self

        // Handle the radius text field's user input through delegate callbacks
        radiusInput.delegate = self

        // Set up views if editing an existing Item.
        if let item = item {
            navigationItem.title = item.name
            nameTextField.text = item.name
            photo = item.photo
            rowNum = item.rowNum
            latitude = item.latitude!
            longitude = item.longitude!
            radius = item.radius!
            identifier = item.identifier!
            //radiusInput = item.radiusInput
            //photoImageView.image = item.photo
        }

        // Set up circular region on map if one has been previously saved for the item being viewed
        if identifier != "" {
            print(item!)
            let region =  CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius, identifier: identifier)
            mapView.removeOverlays(mapView.overlays)
            manager.startMonitoring(for: region)
            let circleRegion = MKCircle(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius)
            mapView.add(circleRegion)
        }

        // Add gray border to pickerView
        self.pickerView.layer.borderColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha: 1.0).cgColor
        self.pickerView.layer.borderWidth = 1
        self.pickerView.layer.backgroundColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha: 0.8).cgColor

        // Set ItemViewController background image
        //self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        // Set navigation bar back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

        // Hide keyboard if tapped elsewhere
        self.hideKeyboardWithTap()

        // Set up Map View
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.distanceFilter = kCLDistanceFilterNone

        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }

    // Dismisses keyboard if tapped outside of text box
    func hideKeyboardWithTap() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ItemViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // Enable the save button once editing has ended and change the navigation bar title to the item name
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != radiusInput {
            navigationItem.title = textField.text
        }
        updateSaveButtonState()
    }

    //MARK: Navigation and Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddItemMode = presentingViewController is UINavigationController
        if isPresentingInAddItemMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ItemViewController is not inside a navigation controller.")
        }
        dismiss(animated: true, completion: nil)
    }

    // Animation for popup, make it appear larger, then shrink to actual size
    func animateInPopup () {
        self.view.addSubview(howToPopup)
        howToPopup.center = self.view.center

        // Make popup slightly bigger so that animation appears more
        howToPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        howToPopup.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.howToPopup.alpha = 1
            self.howToPopup.transform = CGAffineTransform.identity
        }
    }

    // Animate popup to disappear
    func animateOutPopup () {
        UIView.animate(withDuration: 0.3, animations: {
            self.howToPopup.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.howToPopup.alpha = 0
        }) {(success:Bool) in
            self.howToPopup.removeFromSuperview()
        }
    }

    // Animate the How to Set Map popup
    @IBAction func howToButton(_ sender: Any) {
        animateInPopup()
    }

    // Dismiss the How to Set Map popup
    @IBAction func dismissPopup(_ sender: Any) {
        animateOutPopup()
    }

    // Submit radius value
    @IBAction func enterRadius(_ sender: Any) {
        if ((radiusInput.text)?.isEmpty)! {
            regionRadius = 50
        } else {
            regionRadius = Int(radiusInput.text!)!
        }
    }


    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }

        let name = nameTextField.text ?? ""

        // Set the item to be passed to ItemTableViewController after the unwind segue.
        item = Item(name: name, photo: photo, rowNum: rowNum, latitude: latitude, longitude: longitude, radius: radius, identifier: identifier)
    }

    // Establishes a push notification, help from (https://www.youtube.com/watch?v=5TYKjt-2LMc)
    func notify(title: String, body: String) {
        // Send push notification if the user has authorized notifications
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                // Content of the notification, title is bolded region
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default()

                // Wait 5 seconds after being called to notify user
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)

                let request = UNNotificationRequest(identifier: "forgottenItem", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }

    // For displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }

    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
