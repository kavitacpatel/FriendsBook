//
//  post.swift
//  checklogin
//
//  Created by kavita patel on 3/22/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class Posts
{
    private var _postdescription: String!
    private var _imageurl: String!
    private var _likes: Int!
    private var _usernm: String!
    private var _postkey: String!
    private var _postref: Firebase!
    
    var PostDesc: String!
        {
        return _postdescription
    }
    var ImageUrl: String!
        {
        return _imageurl
    }
    var Likes: Int!
        {
        return _likes
    }
    var UserNm: String!
        {
        return _usernm
    }
    var PostKey: String!
        {
        return _postkey
    }
    init(usernm: String, img: String, desc: String)
    {
        self._postdescription = desc
        self._usernm = usernm
        self._imageurl = img
    }
    init(postkey: String, dict: Dictionary<String, AnyObject>)
    {
      
        self._postkey = postkey
        
        if let desc = dict["description"] as? String
        {
        
            self._postdescription = desc
        }
        if let imgurl = dict["imageurl"] as? String
        {
            self._imageurl = imgurl
        }
        if let like = dict["likes"] as? Int
        {
            self._likes = like
        }
        self._postref = DataService.ds.REF_POST.childByAppendingPath(self._postkey)
    
    }
    func addlike(addlike: Bool)
    {
        if(addlike)
        {
            _likes = _likes + 1
        }
        else
        {
            _likes = _likes - 1
        }
        _postref.childByAppendingPath("likes").setValue(_likes)
        
    }
   

}