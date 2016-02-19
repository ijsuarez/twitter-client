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
    
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    let tapProfileDetail = UITapGestureRecognizer()
    let tapReply = UITapGestureRecognizer()
    let tapRetweet = UITapGestureRecognizer()
    let tapFavorite = UITapGestureRecognizer()
    
    let currentUser = User.currentUser
    
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
            
            if (tweet.isRetweeted != nil && tweet.isRetweeted!) {
                retweetImage.image = UIImage(named: "RetweetIcon-Active")
                retweetCount.textColor = UIColor.greenColor()
            } else {
                retweetImage.image = UIImage(named: "RetweetIcon")
                retweetCount.textColor = UIColor.grayColor()
            }
            
            if (tweet.isFavorited != nil && tweet.isFavorited!) {
                favoriteImage.image = UIImage(named: "FavoriteIcon-Active")
                favoriteCount.textColor = UIColor.redColor()
            } else {
                favoriteImage.image = UIImage(named: "FavoriteIcon")
                favoriteCount.textColor = UIColor.grayColor()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.layer.cornerRadius = 8.0
        profileImage.clipsToBounds = true
        
        tapProfileDetail.addTarget(self, action: "profileDetailSegue")
        profileImage.addGestureRecognizer(tapProfileDetail)
        profileImage.userInteractionEnabled = true
        
        tapReply.addTarget(self, action: "replySegue")
        replyImage.addGestureRecognizer(tapReply)
        replyImage.userInteractionEnabled = true
        
        tapRetweet.addTarget(self, action: "retweet")
        retweetImage.addGestureRecognizer(tapRetweet)
        retweetImage.userInteractionEnabled = true
        
        tapFavorite.addTarget(self, action: "favorite")
        favoriteImage.addGestureRecognizer(tapFavorite)
        favoriteImage.userInteractionEnabled = true
        
        tweetContent.preferredMaxLayoutWidth = tweetContent.frame.size.width
    }
    
    func profileDetailSegue() {
        NSNotificationCenter.defaultCenter().postNotificationName("profileDetailNotification", object: nil, userInfo: ["user" : tweet.user!])
    }
    
    func replySegue() {
        NSNotificationCenter.defaultCenter().postNotificationName("replyNotification", object: nil, userInfo: ["reply_tweet" : tweet])
    }
    
    func retweet() {
        if (tweet.isRetweeted != nil && !tweet.isRetweeted! && tweet.user!.name != currentUser!.name) {
            TwitterClient.sharedInstance.retweetWithTweetId(tweet.id!, completion: { (tweet, error) -> () in
                let tempTweet = self.tweet
                tempTweet.retweets!++
                tempTweet.isRetweeted = true
                tempTweet.originalId = tweet?.originalId
                self.tweet = tempTweet
            })
        } else if (tweet.isRetweeted != nil && tweet.isRetweeted!) {
            TwitterClient.sharedInstance.untweetWithTweetId(tweet.originalId!, completion: { (tweet, error) -> () in
                let tempTweet = self.tweet
                tempTweet.retweets!--
                tempTweet.isRetweeted = false
                self.tweet = tempTweet
            })
        }
    }
    
    func favorite() {
        if (tweet.isFavorited != nil && !tweet.isFavorited!) {
            TwitterClient.sharedInstance.favoriteWithTweetId(tweet.id!, completion: { (tweet, error) -> () in
                let tempTweet = self.tweet
                tempTweet.favorites!++
                tempTweet.isFavorited = true
                self.tweet = tempTweet
            })
        } else if (tweet.isFavorited != nil && tweet.isFavorited!) {
            TwitterClient.sharedInstance.unfavoriteWithTweetId(tweet.id!, completion: { (tweet, error) -> () in
                let tempTweet = self.tweet
                tempTweet.favorites!--
                tempTweet.isFavorited = false
                self.tweet = tempTweet
            })
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
