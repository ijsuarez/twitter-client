//
//  ProfileDetailViewController.swift
//  TwitLite
//
//  Created by Labuser on 2/18/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ProfileDetailViewController: UIViewController {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var profileImageContainer: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if user.profileBackgroundUrl != nil {
            headerImage.setImageWithURL(NSURL(string: user!.profileBackgroundUrl!)!)
        } else {
            let bgColor = UIColorFromRGB("0xFF\(headerImage.backgroundColor)")
            headerImage.backgroundColor = bgColor
        }
        
        profileImage.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
        profileImage.layer.cornerRadius = 8.0
        profileImage.clipsToBounds = true
        profileImageContainer.layer.cornerRadius = 8.0
        profileImageContainer.clipsToBounds = true
        
        username.text = user.name
        userHandle.text = "@\(user.screenname!)"
        profileDescription.text = user.tagline
        numFollowing.text = String(user.numFollowing!)
        numFollowers.text = String(user.numFollowers!)
        numTweets.text = String(user.numTweets!)
    }
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        let scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
                
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
