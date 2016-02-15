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
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    let tapRetweet = UITapGestureRecognizer()
    let tapFavorite = UITapGestureRecognizer()
    
    var tweet : Tweet! {
        didSet {
            username.text = tweet.user!.name
            userHandle.text = "@\(tweet.user!.screenname!)"
            tweetContent.text = tweet.text
            profileImage.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!)!)
            
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Month, .Day, .Year], fromDate: tweet.createdAt!)
            
            timestamp.text = "\(comp.month)/\(comp.day)/\(comp.year)"
            
            retweetCount.text = String(tweet.retweets!)
            if tweet.retweets > 0 {
                retweetCount.hidden = false
            } else {
                retweetCount.hidden = true
            }
            
            favoriteCount.text = String(tweet.favorites!)
            if tweet.favorites > 0 {
                favoriteCount.hidden = false
            } else {
                favoriteCount.hidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (tweet.isRetweeted != nil && !tweet.isRetweeted!) {
            tapRetweet.addTarget(self, action: "retweet")
            retweetImage.addGestureRecognizer(tapRetweet)
            retweetImage.userInteractionEnabled = true;
        } else if (tweet.isRetweeted != nil && tweet.isRetweeted!) {
            retweetImage.image = UIImage(named: "RetweetIcon-Active")
            retweetCount.textColor = UIColor.greenColor()
        }
        
        if (tweet.isFavorited != nil && !tweet.isFavorited!) {
            tapFavorite.addTarget(self, action: "favorite")
            favoriteImage.addGestureRecognizer(tapFavorite)
            favoriteImage.userInteractionEnabled = true;
        } else if (tweet.isFavorited != nil && tweet.isFavorited!) {
            favoriteImage.image = UIImage(named: "FavoriteIcon-Active")
            favoriteCount.textColor = UIColor.redColor()
        }
        
        tweetContent.preferredMaxLayoutWidth = tweetContent.frame.size.width
    }
    
    func retweet() {
        if (tweet.isRetweeted != nil && !tweet.isRetweeted!) {
            TwitterClient.sharedInstance.retweetWithTweetId(tweet.id!)
            retweetImage.image = UIImage(named: "RetweetIcon-Active")
            retweetCount.text = String(tweet.retweets!+1)
            retweetCount.textColor = UIColor.greenColor()
            retweetCount.hidden = false
        } else if (tweet.isRetweeted != nil && tweet.isRetweeted!) {
        
        }
    }
    
    func favorite() {
        if (tweet.isFavorited != nil && !tweet.isFavorited!) {
            TwitterClient.sharedInstance.favoriteWithTweetId(tweet.id!)
            favoriteImage.image = UIImage(named: "FavoriteIcon-Active")
            favoriteCount.text = String(tweet.favorites!+1)
            favoriteCount.textColor = UIColor.redColor()
            favoriteCount.hidden = false
        } else if (tweet.isFavorited != nil && tweet.isFavorited!) {
            
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
