# NotifiKeytion
CS50 Final Project

NotifiKeytion is an iOS app that sends a notification to the user when they forget their keys when they leave a self-designated area (such as a dorm room). The
key omits a signal through a bluetooth beacon which allows the app to know the relative proximity of the key. When the user leaves the area, the app checks how
far away the key is by finding the key's relative proximity through the bluetooth beacon signal. If the key is in "immediate" range (slightly less than a meter)
of the phone, no notification is sent. If the key is greater than one meter away from the phone (near, far, and unknown range) when the user leaves the area, a
notification is sent to the user asking: "Did you forget your [name of item (keys)]?"

The app itself includes a launch screen of a key icon, a home screen with a navigation controller and a table view, an "Add New Item" page, an the ability to
edit and delete previously saved items. The "Add New Item" page includes a field to add a name, select an item type, input a radius value, and add a circular
monitoring region to a depicted map. The map is centered at the user's current location (granted that the user allowed location service access upon first use
of NotifiKeytion). Both the "Home" screen and the "Add New Item" screen include popups explaining how to use the app ("Home" screen) and how to use the map
("Add New Item" screen).

NotifiKeytion can also remind the user when they forget other items. However, each item must have a unique bluetooth beacon.

## Getting Started

These instructions will show you how to compile, configure, and use Notifikeytion on your local machine for development and testing purposes.

### Prerequisites

Apple's development environment for MacOS, Xcode, must be installed. The Xcode download can be found at <https://developer.apple.com/xcode/downloads/>.
The `NotifiKeytion.xcodeproj` will need to be opened along with the accompanying folders (NotifiKeytion and NotifiKeytionTests).

**Hardware necessary** is an iOS device (to run app) and a bluetooth beacon that must be configured in `ItemViewController.swift` at the `rangeBeacons()` function:

```
// Configure bluetooth beacon
    func rangeBeacons() {
        let proximityUUID = UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")
        let major:CLBeaconMajorValue = 10002
        let minor:CLBeaconMinorValue = 34452
        let beaconID = "com.example.myBeaconRegion"
```

### Installing

1. Download `NotifiKeytion` folder including two more folders and one file: one folder entitled `NotifiKeytion`, one file entitled `NotifiKeytion.xcodeproj`,
and the second folder entitled `NotifiKeytionTests`.
2. In Downloads folder, double click the `NotifiKeytion.xcodeproj` to open in Xcode.
3. Project should now be open in Xcode.

### Relevant Documents

Documents I actually wrote code and worked with are as follows:
* `AppDelegate.swift`
* `Info.plist`
* `Item.swift`
* `ItemTableViewCell.swift`
* `ItemTableViewController.swift` (most important)
* `ItemViewController.swift` (most important)

## Compile and Configure

1. Plug in your iOS device and allow the computer to recognize and trust the device
2. On Xcode, switch device to your device name at the top left of the Xcode progam, or by following `Window > Devices and Simulators` and selecting you device.
3. Press Command+R to download NotifiKeytion on your device (make sure device is unlocked).
4. On your iOS device, before NotifiKeytion can run, navigate to `Settings > General > Profiles & Device Management > sklucioni@gmail.com > Trust`.
5. Return to Xcode and again press Command+R to run NotifiKeytion (make sure device is unlocked). You may unplug your device.
6. Upon opening the app, NotifiKeytion will ask you to allow notifications to be sent. Press `Allow`.
7. Tap the `How to Use` button for information about how to use NotifiKeytion (also shown below).
    ```
    1. Allow NotifiKeytion to send notifications and access location services when prompted by the app.
    2. Press the plus button to add an item.
    3. On the "New Item" page, add a name, select an item type, and learn how to set up the map, entering in a radius value if desired (default radius = 50m).
    4. Save item.
    5. Edit saved items listed on the home screen by tapping on the item cell.
    6. Delete and item by swiping left or by pressing "Edit."
    ```
8. Tap the `plus` button. NotifiKeytion will ask you to allow access to your location. Press `Always Allow`.

## Usage and Deployment

1. Starting on the home page, tap the `plus` button in the upper righthand corner.
2. Register your item by giving it a name in the `Name` field. Touch elsewhere to dismiss the keyboard and enable the `Save` button.
3. On the picker, drag up and down to choose the type of item.
4. Click the `How?` button next to the `Set Map` label to find out how to configure the map (also shown below).
    ```
    Press and hold on the map at the center coordinate of your desired region to initialize a circular region.
    ```
    (Precisely, hold down the map for 1.5 seconds to initialize a circular region)
5. If desired, enter a value (in meters) for the radius of the circular region. Press `Enter` and reset the map.
6. Press the `Save` button when satisfied with item. If not satisfied, continue to make changes, or press `Cancel` to delete the item.
7. Back on the home screen, either return to step 1 to add another item, or tap the current item displayed to edit, or slide left on the item or press `edit`
to delete the item.
8. To test the notification system, open the desired item connected to the bluetooth beacon. Leave your chosen region (you can simulate leaving the region by
changing your location through Xcode if your device is still connected to your Mac). An alert will popup telling you that you have left the region (this alert
is for developer information and would be removed before hitting the market). Dismiss the alert and put your device in sleep. If you are forgetting your item,
a ~~notifiKeytion~~ notification will ring asking if you are forgetting your ~~key~~ item.
9. Remember your ~~key~~ item every time!

## Built With

* [Swift](https://developer.apple.com/swift/) - programming language used
* [Xcode](https://developer.apple.com/xcode/downloads/) - Apple's development environment
* [Iotton Beacon](https://www.amazon.com/Beacon-navigation-advertisement-broadcasting-prototyping/dp/B01MU7YC87/ref=sr_1_6?m=AML8UOJOXK94Q&s=merchant-items&ie=UTF8&qid=1512642973&sr=1-6) - Iottan bluetooth beacon

## Sources

Helpful and important sources while learning Swift and working on Notifikeytion were as follows:

### Help

* [Swift Introduction](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html) - Apple's Swift tutorial
* [Swift Foodtracker Tutorial](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/) - Apple's Foodtracker tutorial helped with NotifiKeytion's table view, navigation, edit/delete, and persisting data capabilities
* [Popup](https://www.youtube.com/watch?v=CXvOS6hYADc) - Youtube tutorial that taught me how to create a popup
* [Geofence](https://www.youtube.com/watch?v=0p7OPVXsMk0&t=2110s) - Youtube tutorial that taught me about MapKit, CoreLocation, and was especially helpful with regards to geofencing
* [Dismiss Keyboard](https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift) - Helpful function to dismiss the keyboard
* [Ranging Beacons](https://www.youtube.com/watch?v=_4Qpf5WOBBI) - Youtube tutorial helping me with navigating bluetooth beacons
* [Notifications](https://www.youtube.com/watch?v=5TYKjt-2LMc) - Youtube tutorial helping me with user notifications
* [README file template](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2) - Markdown template helping me organize my README.md
* [DESIGN file template](https://www.toptal.com/freelance/why-design-documents-matter) - Template helping me organize my DESIGN.md

### Images

* [Key Icon](https://pixabay.com/en/key-grey-gray-symbol-sign-unlock-25004/) - Used for logo, launch screen, and key item image
* [ID Icon](http://www.iconarchive.com/show/small-n-flat-icons-by-paomedia/user-id-icon.html) - Used for ID item image
* [Wallet Icon](https://www.flaticon.com/free-icon/wallet_214362#term=wallet&page=1&position=8) - Used for wallet item image
* [Purse Icon](https://icons8.com/icon/37706/red%20purse) - Used for purse item image
* [Dots Icon](https://commons.wikimedia.org/wiki/File:Ios-more-outline.svg) - Used for other item image
* [Background Pattern](http://www.designbolts.com/wp-content/uploads/2012/12/Triangle-White-Seamless-Patterns.jpg) - Used for background pattern

## Authors

* **Sarah Lucioni**
