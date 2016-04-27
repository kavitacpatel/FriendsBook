//
//  PostCell.swift
//  checklogin
//
//  Created by kavita patel on 3/18/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import Firebase


class PostCell: UITableViewCell {

    @IBOutlet weak var lblusernm: UILabel!
    @IBOutlet weak var lbldesc: UITextView!
    @IBOutlet weak var showcaseimg: UIImageView!
    
   
    @IBOutlet weak var deletebtn: UIImageView!
    @IBOutlet weak var lbllikes: UILabel!
    @IBOutlet weak var imglikes: UIImageView!
    var post: Posts!
    var likeref: Firebase!
    var deleteref: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostCell.liketapped(_:)))
        tap.numberOfTapsRequired = 1
        imglikes.addGestureRecognizer(tap)
       imglikes.userInteractionEnabled = true
        let tapdelete = UITapGestureRecognizer(target: self, action: #selector(PostCell.deletetapped(_:)))
       tapdelete.numberOfTapsRequired = 1
        deletebtn.addGestureRecognizer(tapdelete)
        deletebtn.userInteractionEnabled = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
    func liketapped(sender: UITapGestureRecognizer)
    {
        likeref.observeSingleEventOfType(.Value, withBlock: { snapshot in
           if ((snapshot.value as? NSNull) != nil) // we not liked specific post
            {
                self.imglikes.image = UIImage(named: "likered")
                self.post.addlike(true)
                self.likeref.setValue(true)
            }
            else
            {
                self.imglikes.image = UIImage(named: "likewhite")
                self.post.addlike(false)
                self.likeref.removeValue()
            }
        })

    }
    
    func deletetapped(sender: UITapGestureRecognizer)
    {
    // removes all posts  DataService.ds.REF_POST.removeValue()
       deleteref.removeValue()
           }
    
    
    func configCell(post: Posts, img: UIImage?)
    {
         likeref = DataService.ds.REF_CURRENT_USER.childByAppendingPath("likes").childByAppendingPath(post.PostKey)
         deleteref = DataService.ds.REF_POST.childByAppendingPath(post.PostKey)
        self.post = post
        self.lbldesc.text = post.PostDesc
       // self.lblusernm.text = post.UserNm
        self.lbllikes.text = "\(post.Likes)"
        if post.ImageUrl != nil
        {
            if img != nil
            {
                self.showcaseimg.image = img
            }
            else
            {
                let url = NSURL(string: post.ImageUrl)
               let data = NSData(contentsOfURL: url!)
               if data != nil
               {
                let img = UIImage(data: data!)
                self.showcaseimg.image = img
                DetailVc.imgcache.setObject(img!, forKey: self.post.ImageUrl)
                }
                else
               {
                self.showcaseimg.hidden = true
                }
            }
        }
        else
        {
            self.showcaseimg.hidden = true
        }
        
        //handle likes
        
       
        likeref.observeSingleEventOfType(.Value, withBlock: { snapshot in
             if ((snapshot.value as? NSNull) != nil)   // we not liked specific post
             {
                self.imglikes.image = UIImage(named: "likewhite")
                
            }
            else
             {
                self.imglikes.image = UIImage(named: "likered")
            }
        })
    
    
}
}