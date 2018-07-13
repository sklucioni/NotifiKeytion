# NotifiKeytion

## Goals

NotifiKeytion is an iOS app that sends a notification to the user when they forget their keys when they leave a self-designated area (such as a dorm room). The
key omits a signal through a bluetooth beacon which allows the app to know the relative proximity of the key. NotifiKeytion was designed because I have observed
others and myself constantly forgetting our keys in the morning when we rush out of the door.

* **GOOD outcome** (what WILL I accomplish no matter what?):
   I expect to accomplish a very basic iOS app that will be able to receive signals from a bluetooth beacon and send a notification to the user.

* **BETTER outcome** (what do you THINK you can accomplish before the final project's deadline?):
   A better outcome would be a nicer looking iOS app that will be able to receive signals from the bluetooth beacon and send a notification to the user when
   the key is not within a certain range of the phone.

* **BEST outcome** (what do you HOPE to accomplish before the final project's deadline?):
   The best outcome would be a nice iOS app that will be able to receive signals from the bluetooth beacon and send a notification to the user when they are
   leaving a designated area without their key. The user would be able to designate this area easily through the app.

## Functional Description

* Launch Screen
    An ImageView with a colored background.

* Home Page: `ItemTableViewCell.swift and ItemTableViewController.swift`

    I decided to present my home page as a table. This allowed for easy access to each item and I could seamlessly implement a navigation controller throughout
    the app. Using a table view as the front page required me to store each item added by the `plus` button in an array so that I could list each item upon
    re-entry to the app and the ability to persist the data.

    I added a `How to Use` button that transitions to information about the app as a popup. The popup was fun to make because I animated it by increasing it's
    size at first by scaling the X and Y values, and then returning it back to normal within 0.4 seconds. To animate the dissapearance of the popup, I again
    animated the view by transforming the X and Y values and decreasing the opacity to 0 within 0.3 seconds.

    The table view was set up each time by telling it the number of columns (1) and rows (changes depending on number of items). I accessed the name and image
    for each stored item of class Item (written in `Item.swift`) and designed each table cell with the name and corresponding image.

    I also added in edit and delete functionalities for the items in the table view. To delete an item, either swipe left and press `delete` or tap the `edit`
    button and proceed to delete the item. To edit an item, tap the item. This takes you to a similar screen to the `Add New Item` screen. However, the name
    and region (if applicable) are already shown. Each field can be changed. If the `cancel` button is pressed, the item does not get deleted. Instead, the
    item simply returns to the last saved state.

* Add New Item: `ItemViewController.swift`

    To begin, I had to import three additional frameworks: MapKit (to access map functionality), CoreLocation (to access location functionality), and
    UserNotifications (to send notifications to users). These frameworks allowed me to have access to a lot of objects and classes that helped with my project
    such as accessing user location, accessing beacons, and adding regions to maps.

    To set up the map, I first had to make sure that the user authorized the use of their location. This allowed me to continually know their location,
    including in the background. In the viewDidLoad method, I started updating location which triggered the function that allows access to user location and
    sets the view of the map in the New Item view.

    To add a region to the map, I added a gesture to listen for a long press (1.5 seconds hold). When this occurred, I updated the identifier, latitutde, and
    longitude of the item at hand. In this function, the circular region is also added to the map, however, I had to draw it in the next function to actually
    make it visible. The viewDidLoad method draws the region if the item already has a region when New Item view is loaded. When the region is drawn, the app
    begins to monitor to see if the user will exit the region. If the user does exit the region, an alert function is triggered that sends an alert to the
    user and the rangeBeacons method also is called. The rangeBeacons method sets up the bluetooth beacon and begins looking for a signal from the registered
    beacon. If a beacon is found in the beaconRegion, the proximity of the beacon to the phone is found. If the proximity is "immediate" (approximately less
    than one meter), the region stops monitoring for signals. However, if the beacon is not found, or is farther away in proximity, a notification function
    is called that sends the user a notification asking if they forgot their item using the item name property.

    This page also configures the cancel, save, howTo, and enter buttons as well as the item type pickerView and some other stylistic choices.

* Stylistic Choices:

    color: I chose a light blue color for the navigation bar to remain neutral to stereotypical preferences.
    font: I chose Futura-Medium as my font for the Navigation Controller because it was different, but easy to read and look at.
    background: I chose a slightly gray-colored and patterned background to be interesting, and pleasing, but not distracting.
    arrangement: I arranged each page simply so that it would not feel like a huge amount of information was being shoved at the user.

## User Interface

* Home Page
    * Navigation Bar:
        * Left button allows for deletion of items listed
        * Name of app in the middle
        * Plus button allows for addition of a new item
    * Item:
        * Shows name on the left
        * Shows image on the right
        * Tapping on item redirects to page where you can edit item
    * How to Use:
        * Button that triggers popup view with information on how to use the app

* New Item:
    * Navigation Bar:
        * Left button allows for cancellation of item being initialized
        * Name of screen in the middle until name of item is added (becomes name of item)
        * Save button allows for item to be stored
    * Name Field:
        * Alphabetical/Numerical name can be stored, placeholder disappears
        * Disables save button
        * Keyboard must be dismissed in order to enable save button
    * Picker View:
        * List of item types that can be chosen (key, ID, wallet, purse, other)
        * Drag up and down to choose
    * Set Map label with How? button:
        * Button that triggers popup view with information on how to set a region on the map
    * Radius Field:
        * Numerical name can be stored, placeholder disappears
        * Disables save button
        * Keyboard must be dismissed in order to enable save button
        * Enter button must be pressed in order to store radius value (default value is 50 meters)
    * Map:
        * Shows current location
        * Depicts region if one is already established
        * Long press draws a new circular region
        * Can zoom in/out and move map around

### Milestones

1. Pseudocode (especially for when to send notification)
2. Design mockup on paper
3. Functional Milestone 1: iOS blank home page with navigation bar
4. Completion of "New Item" page
5. Edit and delete items
6. Persist data
7. Functional Milestone 2: App continues to save data and functionality after terminating
8. Launch Screen
9. Researching bluetooth beacons
10. Map
11. Send notification
12. Geofence
13. Functional Milestone 3: Notification sends when user leaves region without item

## Conclusion

Methods that need improvement in my app are the exit region functionality and the ability to register a bluetooth beacon to an item. The exit region is not
super precise and takes some time to register that the user has left the region. In conclusion, the app works, but would most likely remind you about
forgetting your desired item after you have already left the building/region where your item is (which is still better than going all the way across town
without your item!)
