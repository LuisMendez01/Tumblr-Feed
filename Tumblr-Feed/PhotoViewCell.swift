//
//  PhotoViewCell.swift
//  Tumblr-Feed
//
//  Created by Luis Mendez on 9/12/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class PhotoViewCell: UITableViewCell {

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
