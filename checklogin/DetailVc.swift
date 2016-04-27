//
//  DetailVc.swift
//  checklogin
//
//  Created by kavita patel on 3/18/16.
//  Copyright © 2016 kavita patel. All rights reserved.

import UIKit
import Cloudinary

import Firebase


class DetailVc: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLUploaderDelegate{

    @IBOutlet weak var cameraimg: UIImageView!
    @IBOutlet weak var postfield: txtview!
    @IBOutlet weak var tableview: UITableView!
    var posts = [Posts]()
    var imagepicker: UIImagePickerController!
    static var imgcache = NSCache()
    var cloudinary: CLCloudinary!
    let Cloudinary_url = "cloudinary://184229596387444:wDYo1bdeSiGUYWD1MwY8JgPjJzo@dlginqanp"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableview.dataSource = self
        tableview.delegate = self
        imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        DataService.ds.REF_POST.observeEventType(.Value, withBlock: { snapshot in
        self.tableview.estimatedRowHeight = 333
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]
            {
            for snap in snapshots
            {
               
                    if let postdict = snap.value as? Dictionary<String, AnyObject>{
                    
                    let key = snap.key
                    let post = Posts(postkey: key, dict: postdict)
                    self.posts.append(post)
                                    }
            }
            }
            self.tableview.reloadData()
            })
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell
        {
            
            var img: UIImage?
            if let url = post.ImageUrl
            {
                img = DetailVc.imgcache.objectForKey(url) as? UIImage
            }
            cell.configCell(post, img: img)
            return cell
        }
        else
        {
            return PostCell()
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if post.ImageUrl == nil
        {
            return 150
        }
        else
        {
            return tableview.estimatedRowHeight
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
         imagepicker.dismissViewControllerAnimated(true, completion: nil)
         cameraimg.image = image
    }
   
    @IBAction func selectimg(sender: UITapGestureRecognizer) {
        presentViewController(imagepicker, animated: true, completion: nil)
       
    }
    
    @IBAction func postbutton(sender: AnyObject) {
        if let txt = postfield.text where txt != ""
        {
            if let img = cameraimg.image
            {
            
            // let urlstr = "https://api.cloudinary.com/v1_1/dlginqanp/image/upload"
              let clouder = CLCloudinary(url: Cloudinary_url)!
                let imgdata = UIImageJPEGRepresentation(img, 0.4)
                let uploader: CLUploader = CLUploader(clouder, delegate: self)
                var url_str: String!
                uploader.upload(imgdata, options: nil, withCompletion: { (dataDictionary: [NSObject : AnyObject]!, error: String!, code: Int, context: AnyObject!) -> Void in
                    if code < 400
                    {
                     print("upload successfully")
                       
                        for (key, value) in dataDictionary {
                            if key == "secure_url"
                            {
                             url_str = value as! String
                            }
                        }

                    self.posttofirebase(url_str)
                    }
                    else{
                        print("uploading failed")
                    }
            
                    },andProgress: { (bytesWritten:Int, totalBytesWritten:Int, totalBytesExpectedToWrite:Int, context:AnyObject!) -> Void in
                       // print("Upload progress: \((totalBytesWritten * 100)/totalBytesExpectedToWrite) %");
                    })
                
            }
        }
        else
        {
            self.posttofirebase(nil)
        }
    }
   
        func posttofirebase(imgurl:String?)
    {
        let fbpost: Dictionary<String, AnyObject>!
        if imgurl != nil
        {
            
             fbpost = [
                "description": postfield.text!,
                "likes": 0,
                "imageurl": imgurl!
            ]
        }
        else{
            
             fbpost = [
                "description": postfield.text!,
                "likes": 0
            ]
        }
        let firebasepost = DataService.ds.REF_POST.childByAutoId()
        firebasepost.setValue(fbpost)
        
        postfield.text = ""
        cameraimg.image = UIImage(named: "camera.jpg")
        tableview.reloadData()
    }
       }
