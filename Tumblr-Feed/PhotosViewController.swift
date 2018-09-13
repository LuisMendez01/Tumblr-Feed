//
//  PhotosViewController.swift
//  Tumblr-Feed
//
//  Created by Luis Mendez on 9/11/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //1.This property will store the data returned from the network request. It's convention to create properties near the top of the view controller class where we create our outlets.
    
    //2.Looking at the sample request in the browser, we see the photos key returns an array of dictionaries so that's what type we will make our property.
    
    //3.We will initialize it as an empty array so we don't have to worry about it ever being nil later on such as this case in numberOfRowsInSection when we'll returned posts.count could 0
    
    // 1.          2.             3.
    var posts: [[String: Any]] = []
    var refreshControl: UIRefreshControl!//! means better not be null or else crashes
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 250
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)//0 means it will show on the top
        
        self.activityIndicator.startAnimating()//start the indicator before reloading data
        
        self.fetchPhotos()//get now playing movies from the APIs

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    func fetchPhotos() {
        
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                
                print(error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
                    // Your code with delay
                    self.offLineAlert()//show alert
                }
                
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                // TODO: Reload the table view
                
                //reload table once we get all our info in the JSON
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()//stop indicator coz data is acquired
                self.refreshControl.endRefreshing()//stop refresh when data has been acquired
            }
        }
            task.resume()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.fetchPhotos()//get now playing movies from the APIs
        }
    }
    
    func offLineAlert() {
        
        let alertController = UIAlertController(title: "Can't Fetch Photos", message: "Internet connection appears to be offline", preferredStyle: .alert)
        
        // create an TryAgainAction action
        let TryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
            // handle response here.
            alertController.dismiss(animated: true, completion: nil)
            self.activityIndicator.startAnimating()//start the indicator before reloading data
            self.fetchPhotos()//get now playing movies from the APIs
        }
        // add the Try Again action to the alert controller
        alertController.addAction(TryAgainAction)
        
        self.present(alertController, animated: true, completion: nil)
        /*
         self.present(alertController, animated: true) {
         // optional code for what happens after the alert controller has finished presenting
            
         }
        */
    }
    
    /***********************
     * TableView functions *
     ***********************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure YourCustomCell using the outlets that you've defined.
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! PhotoViewCell
        
        // Use a Dark blue color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.4699950814, green: 0.6678406, blue: 0.8381099105, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        let post = posts[indexPath.row]
        
        //1. It's possible that we may get a nil value for an element in the photos array, i.e. maybe no photos exist for a given post. We can check to make sure it is not nil before unwrapping. We can check using a shorthand swift syntax called if let
        
        //2. post is an array of dictionary containing information about the post. We can access the photos array of a post using a key and subscript syntax.
        
        //3. photos contains an array of dictionaries so we will cast as such.
        
        // 1.            // 2.          // 3.
        if let photos = post["photos"] as? [[String: Any]] {
            // photos is NOT nil, we can use it!
            // 💡 This is the url location of the image. We'll use our AlamofireImge helper method to fetch that image once we get the url.
            
            // 1. Get the first photo in the photos array
            let photo = photos[0]
            // 2. Get the original size dictionary from the photo
            let originalSize = photo["original_size"] as! [String: Any]
            // 3. Get the url string from the original size dictionary
            let urlString = originalSize["url"] as! String
            // 4. Create a URL using the urlString
            let url = URL(string: urlString)
            
            let placeholderImage = UIImage(named: "house2.png")
 
            cell.photoImageView.af_setImage(
                withURL: url!,
                placeholderImage: placeholderImage,
                imageTransition: .crossDissolve(2),
                runImageTransitionIfCached: false,
                completion: (nil)
            )
        }
        
        return cell
    }

}
