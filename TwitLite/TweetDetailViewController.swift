//
//  TweetDetailViewController.swift
//  TwitLite
//
//  Created by Labuser on 2/16/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    let tapProfileDetail = UITapGestureRecognizer()
    let tapReply = UITapGestureRecognizer()
    let tapRetweet = UITapGestureRecognizer()
    let tapLike = UITapGestureRecognizer()
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        retweetImage.userInteractionEnabled = true;
        
        tapLike.addTarget(self, action: "favorite")
        likeImage.addGestureRecognizer(tapLike)
        likeImage.userInteractionEnabled = true;
        
        tweetContent.preferredMaxLayoutWidth = tweetContent.frame.size.width
        
        updateDetails()
    }
    
    func updateDetails() {
        username.text = tweet.user!.name
        userHandle.text = "@\(tweet.user!.screenname!)"
        tweetContent.text = tweet.text
        profileImage.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!)!)
        
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute, .Month, .Day, .Year], fromDate: tweet.createdAt!)
        
        if (comp.hour == 0) {
            timestamp.text = "12:\(comp.minute) AM - \(comp.month)/\(comp.day)/\(comp.year)"
        } else if (comp.hour < 12) {
            timestamp.text = "\(comp.hour):\(comp.minute) AM - \(comp.month)/\(comp.day)/\(comp.year)"
        } else if (comp.hour == 12) {
            timestamp.text = "12:\(comp.minute) PM - \(comp.month)/\(comp.day)/\(comp.year)"
        } else {
            timestamp.text = "\(comp.hour % 12):\(comp.minute) PM - \(comp.month)/\(comp.day)/\(comp.year)"
        }
        
        numRetweets.text = String(tweet.retweets!)
        retweetLabel.text = "Retweets"
        if tweet.retweets == 1 {
            retweetLabel.text = "Retweet"
        } /*else if tweet.retweets == 0 {
            //numRetweets.hidden = true
            numRetweets.text = ""
            retweetLabel.text = ""
        }*/
        
        numLikes.text = String(tweet.favorites!)
        likeLabel.text = "Likes"
        if tweet.favorites == 1 {
            likeLabel.text = "Like"
        } /*else if tweet.favorites == 0 {
            numLikes.text = ""
            likeLabel.text = ""
        }*/
        
        if (tweet.isRetweeted != nil && tweet.isRetweeted!) {
            retweetImage.image = UIImage(named: "RetweetIcon-Active")
        } else {
            retweetImage.image = UIImage(named: "RetweetIcon")
        }
        
        if (tweet.isFavorited != nil && tweet.isFavorited!) {
            likeImage.image = UIImage(named: "FavoriteIcon-Active")
        } else {
            likeImage.image = UIImage(named: "FavoriteIcon")
        }
    }
    
    func profileDetailSegue() {
        performSegueWithIdentifier("ProfileDetailSegue", sender: tweet.user)
    }
    
    func replySegue() {
        performSegueWithIdentifier("ReplySegue", sender: tweet)
    }
    
    func retweet() {
        if (tweet.isRetweeted != nil && !tweet.isRetweeted!) {
            TwitterClient.sharedInstance.retweetWithTweetId(tweet.id!, completion: { (tweet, error) -> () in
                let tempTweet = self.tweet
                tempTweet.retweets!++
                tempTweet.isRetweeted = true
                tempTweet.originalId = tweet?.originalId
                self.tweet = tempTweet
                self.updateDetails()
            })
        } else if (tweet.isRetweeted != nil && tweet.isRetweeted!) {
            TwitterClient.sharedInstance.untweetWithTweetId(tweet.originalId!, completion: { (tweet, error) -> () in
                let tempTweet = self.tweet
                tempTweet.retweets!--
                tempTweet.isRetweeted = false
                self.tweet = tempTweet
                self.updateDetails()
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
                self.updateDetails()
            })
        } else if (tweet.isFavorited != nil && tweet.isFavorited!) {
            TwitterClient.sharedInstance.unfavoriteWithTweetId(tweet.id!, completion: { (tweet, error) -> () in
                let tempTweet = self.tweet
                tempTweet.favorites!--
                tempTweet.isFavorited = false
                self.tweet = tempTweet
                self.updateDetails()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ProfileDetailSegue" {
            let user = sender as! User
            let profileDetailViewController = segue.destinationViewController as! ProfileDetailViewController
            profileDetailViewController.user = user
        } else if segue.identifier == "ReplySegue" {
            let tweet = sender as! Tweet
            let composeViewController = segue.destinationViewController as! ComposeViewController
            composeViewController.replyTo = tweet
        }
    }

}
