//
//  TweetCell.swift
//  TwitLite
//
//  Created by Labuser on 2/14/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    
    var tweet : Tweet! {
        didSet {
            username.text = tweet.user!.name
            userHandle.text = "@\(tweet.user!.screenname!)"
            tweetContent.text = tweet.text
            print(tweet.text)
            profileImage.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!)!)
            
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Month, .Day, .Year], fromDate: tweet.createdAt!)
            
            timestamp.text = "\(comp.month)/\(comp.day)/\(comp.year)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetContent.preferredMaxLayoutWidth = tweetContent.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
