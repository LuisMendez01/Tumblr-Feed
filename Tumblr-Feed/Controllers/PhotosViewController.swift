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
    
    var checked: [Bool]!//for checkmark on row clicked
    
    var isMoreDataLoading = false//to make sure data has already been loaded
    
    var loadingMoreView:InfiniteScrollActivityView?
    
    var limit: Int = 10
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 250
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)//0 means it will show on the top
        
        self.activityIndicator.startAnimating()//start the indicator before reloading data
        
        loadingMoreView = InfiniteScrollActivityView()//instantiate the object
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += 45//InfiniteScrollActivityView.defaultHeight -> 60
        print("HL \(InfiniteScrollActivityView.defaultHeight)")
        tableView.contentInset = insets
        
        self.fetchPhotos()//get now playing movies from the APIs

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /***********************
     * TableView functions *
     ***********************/
    func numberOfSections(in tableView: UITableView) -> Int {
        print(posts.count)
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure YourCustomCell using the outlets that you've defined.
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! PhotoViewCell
        
        // Use a Dark blue color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.4699950814, green: 0.6678406, blue: 0.8381099105, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        let post = posts[indexPath.section]
        
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
            
            //check for row clicked on
            if checked[indexPath.section] {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        let post = posts[section]
        let stringDate = post["date"] as? String
        
        let dateFormatter = DateFormatter()//dateFormat has to look same as string data coming in
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"//data extracted looks like this -> 2018-09-03 22:49:17 GMT
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        dateFormatter.isLenient = true
        //print(type(of: stringDate))
        
        let date = dateFormatter.date(from: stringDate!)
        //print(date!)
        
        //this will make date coming like this 2018-09-03 22:49:17 GMT turn like this //MMM d, yyyy, HH:mm a
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        // let label = ...
        let labelDate = UILabel(frame: CGRect(x: 55, y: 10, width: 250, height: 30))
            labelDate.textAlignment = .left
            labelDate.text = dateFormatter.string(from: date ?? Date())
        
            headerView.addSubview(labelDate)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect the row selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        checked[indexPath.section] = !checked[indexPath.section]
        tableView.reloadRows(at: [indexPath], with: .automatic)

    }
    
    func setSelected(selected: Bool, animated: Bool) {
         // Use a red color when the user selects the cell
        // let fontSize: CGFloat = selected ? 34.0 : 17.0
        //self.textLabel?.font = self.textLabel?.font.fontWithSize(fontSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height//size of content of whole table, all data requested
            let phoneFrame = tableView.frame.height//height of the phone
            let scrollOffsetThreshold = scrollViewContentHeight - phoneFrame//when reached end of table to start requesting more data
            /*************************************************************************************
             * tableView.contentSize.height -> contentSize is just an estimated value initially. *
             * If you need to use the contentSize, you’ll want to disable estimated heights by   *
             * setting the 3 estimated height properties to zero:                                *
             *************************************************************************************/
            //tableView.estimatedRowHeight = 0//NOTE: there is no need to do this, estimated values work same way
            //tableView.estimatedSectionHeaderHeight = 0
            //tableView.estimatedSectionFooterHeight = 0
            
            //print(tableView.contentSize.height)
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > (scrollOffsetThreshold + 60) && tableView.isTracking) {
                
                var insets = tableView.contentInset
                insets.bottom += 45//InfiniteScrollActivityView.defaultHeight -> 60
                tableView.contentInset = insets
                
                print("beginBatchFetch")
                
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                //width same as table width, height same as default indicator
                //position x start from the very most left and y start right after the table end
                let frame = CGRect(x: 0, y: tableView.contentSize.height-8, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                
                loadingMoreView?.frame = frame//this is how big indicator will be and positioned
                loadingMoreView!.startAnimating()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Code to load more results
                self.fetchPhotos()
                }
            }
        }
    }
    
    /*******************
     * @OBJC FUNCTIONS *
     *******************/
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.fetchPhotos()//get now playing movies from the APIs
        }
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    func fetchPhotos() {
        
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&limit=\(limit)")!
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
                
                self.limit = self.limit+10
                
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                // TODO: Reload the table view
                
                // ... Use the new data to update the data source ...
                //applied lateness to see the transition of indicator and reload data
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                    
                    self.activityIndicator.stopAnimating()//stop indicator coz data is acquired
                    self.refreshControl.endRefreshing()//stop refresh when data has been acquired
                    
                    self.checked = [Bool](repeating: false, count: self.posts.count+1)
                    
                    // Update flag in scrollViewDidScroll that data has been requested
                    self.isMoreDataLoading = false
                    
                    var insets = self.tableView.contentInset
                    insets.bottom -= 45//InfiniteScrollActivityView.defaultHeight -> 60
                    self.tableView.contentInset = insets
                
                    // Stop the loading indicator
                    self.loadingMoreView!.stopAnimating()
                    
                    // Reload the tableView now that there is new data
                    self.tableView.reloadData()
                }
            }
        }
            task.resume()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //This is another way to get the indexPath!
        //let cell = sender as! UITableViewCell
        //let indexPath = tableView.indexPath(for: cell)!
        //check for row clicked on
       
        if let indexPath = tableView.indexPathForSelectedRow{
            
            let selectedRow = indexPath.section
            let destinationVC = segue.destination as! PhotoDetailsViewController
            
            //can have diff segues say for btn1 and for btn2, but
            //since I'm using table then even and row cells are used here
            if segue.identifier == "otherSegue" || selectedRow%2 == 0 {
                destinationVC.title = "Green"
                destinationVC.view.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            } else if segue.identifier == "showPhotoSegue" && selectedRow%2 == 1 {
                destinationVC.title = "Blue"
                destinationVC.view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            }
            
            let post = posts[selectedRow]
            
            if let photos = post["photos"] as? [[String: Any]] {
                
                // 1. Get the first photo in the photos array
                let photo = photos[0]
                // 2. Get the original size dictionary from the photo
                let originalSize = photo["original_size"] as! [String: Any]
                // 3. Get the url string from the original size dictionary
                let urlString = originalSize["url"] as! String
                // 4. Create a URL using the urlString
                let url = URL(string: urlString)
                
                destinationVC.url = url!
            }
        }
    }
}

//This goes in appDelegate to create a VC and add NavController
/*
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
 var window: UIWindow?
 
 func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 
 //Step 1: Instantiate the root view controller for the navigation controller
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 let pickColorVC = storyboard.instantiateViewController(withIdentifier: "PickAColor") as UIViewController
 
 Step 2: Create navigation controller with root view controller
 let navigationController = UINavigationController(rootViewController: pickColorVC)
 
 window = UIWindow(frame: UIScreen.main.bounds)
 if let window = window {
 window.rootViewController = navigationController
 window.makeKeyAndVisible()
 }
 return true
 }
 ...
 }
 */

//Step 3: Respond to events by pushing new view controllers
/*
 class ColorPickerViewController: UIViewController {
 
 @IBAction func didTapRedButton(sender: Any) {
 pushViewController(title: "Red", color: UIColor.red)
 }
 
 @IBAction func didTapBlueButton(sender: Any) {
 pushViewController(title: "Blue", color: UIColor.blue)
 }
 
 private func pushViewController(title: String, color: UIColor) {
 let vc = UIViewController()
 vc.view.backgroundColor = color
 vc.title = title
 self.navigationController?.pushViewController(vc, animated: true)
 }
 }
 */
