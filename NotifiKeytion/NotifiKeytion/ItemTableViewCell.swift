//
//  ItemTableViewCell.swift
//  NotifiKeytion
//
//  Created by Sarah Lucioni on 11/30/17.
//  Copyright © 2017 Sarah Lucioni. All rights reserved.
//
//  Apple Foodtracker tutorial helped with table view, navigation, edit/delete, and persisting data (https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/)
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
