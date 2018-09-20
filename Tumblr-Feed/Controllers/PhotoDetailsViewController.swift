//
//  PhotoDetailsViewController.swift
//  Tumblr-Feed
//
//  Created by Luis Mendez on 9/18/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    
    var url: URL!
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImage.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        print("url: \(String(describing: url))")
        photoImage.af_setImage(withURL: url!)
    }
    
    /************************
     * IBACTION FUNCTIONS *
     ************************/
    //tapGestureRecognizer from Storyboard
    @IBAction func tapToFullScreenPhoto(_ sender: Any) {
        performSegue(withIdentifier: "FullScreenPhoto", sender: nil)
    }
    
    /************************
     * OVERRIDE FUNCTIONS *
     ************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FullScreenPhotoViewController
        destinationVC.url = url
    }
    
}
