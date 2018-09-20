//
//  FullScreenPhotoViewController.swift
//  Tumblr-Feed
//
//  Created by Luis Mendez on 9/19/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import AlamofireImage

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var fullPhotoImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var url: URL!
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        //scrollView.contentSize = CGSize(width: 320, height: 1000)
        scrollView.contentSize = fullPhotoImage!.bounds.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        print("url: \(String(describing: url))")
        fullPhotoImage.af_setImage(withURL: url!)
    }
    
    /************************
     * @IBACTION FUNCTIONS *
     ************************/
    @IBAction func DismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /************************
     * SCROLLING FUNCTIONS *
     ************************/
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullPhotoImage
    }
}
