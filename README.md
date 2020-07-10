Original App Design Project
===

# Happy Mail 

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)
3. [SDKs and Dependecies](#SDKs-and-Dependencies)

## Overview
### Description
This app seeks to spread happiness through the classic medium of cards. Everyone loves receiving a card from a person rather than a corporation. Inspired by the RandomActsOfCards subreddit, this app provides a streamlined and convenient platform where people can either request some of that cheer or offer it in the form of a beautiful card or postcards. The emphasis of Happy Mail is not to send long letters in a penpal style, but rather to put a sprinkle of joy into the cards you send, whether that be through drawings, stickers, quotes, riddles, or any other cheer-bringing personal flair. 

### App Evaluation
- **Category:** Social
- **Mobile:** Having access to other users' information, such as card preferences and addresses, provides an advantage when trying to create happy mail in various places. Rather than needing to go back to one's computer to reference such information, a user can simply carry their phone with them to wherever they wish to send happy mail. Users may also take photos of the cards they receive or wish to send and incorporate them into their posts in a much more streamlined way.
- **Story:** Lets you spread happiness and receive it anywhere via mail. 
- **Market:** Anyone at all can send mail so long as they have an envelope, some paper, and a stamp. Everyone feels happy when they receive mail that is not a bill or advertisement.
- **Habit:** The incorporation of positive feedback via a Thank-You post section as well as the good feelings that come from both sending and receiving mail will keep users coming back to the app.
- **Scope:** The app will provide a forum-style platform for posting offers, requests, and thank-yous as its main feature. Users would be able to respond directly to an offer or request. The app could also automate closing offers that have reached a user-set limit of responses. Users will also be able to maintain a profile with important details such as address, card preferences, and a count of thank-yous received. Additional features might include a map personalized to each user that would mark places the user has sent and/or received mail from. (See more below)

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can create a new account.
    * Users can set address and any other needed info during registration
* Users can login and logout.
* Users sessions persist across app restarts.
* Users can make 2 kinds of posts.
* Users can scroll through 2 kinds of posts:
    * Requests: Asking for cards to be sent
    * Offers: Offering up a specified or non-specified number of cards to send
* Users can look at the details view of a post
* * Users can view follow-ups where they see a user's information and the associated post that they need to follow-up on (by sending a card or marking as unable to complete).
* Users can respond to offers from the details view by sending their information.
* Users can respond to requests with a request for the poster's information.
    * In turn, users can approve giving their information to another user (possibly optional).
* Users can mark follow-ups as completed or unable to complete.
* Users can view their profile
* Users can view other users' profiles
* Users can set their profile picture.

**Optional Nice-to-have Stories**

* Users can view a map that marks places they have sent cards to or received cards (with different colored marks for sent vs received).
* Users can filter posts by type.
* Users can search for posts.
* Users can view the posts they have made from their profile.
* Prevent duplication of post responses
* Users can view a third type of post: thank-yous
    * Thank Yous: Thanking user(s) for received cards
* When posting a thank-you, users can tag other users.
* Users can manually mark offers or requests as finished.
* Users can have offers automatically close after a certain amount of responses.
* Users can change their personal information from their profile.
* Users can mark or set regions they are willing to send to.
* Users' personal card-sending score with increase for each thank you posted for them.
* Users can view all the thank yous they are tagged in.
* Users are notified when another user is unable to complete a request from you or an offer made by them.
* Users can like posts.
* Users receive a notification within the app whenever someone is requesting information from them.
* Users can attach photos to posts.


### 2. Screen Archetypes

* Login
    * User can login
    * User sessions persist across app restarts (implemented in SceneDelegate, skips the Login screen).
* Registration
    * User can create a new account
    * Users can set information like address 
* Your Profile
   * Users can logout
   * Users can set their profile picture
   * Possibly setting and changing personal information such as address, preference of cards vs postcards, etc.
* Stream 2 kinds of posts
    * Users can scroll through 2 kinds of posts
* Requests - details screen
    * Users can look at the details view of a post
    * Users can respond to requests with a request for the poster's information (button click -> pop up)
    * In turn, users can approve giving their information to another user (in follow-ups)
* Offers - details screen
    * Users can look at the details view of a post
    * Users can respond to offers from the details view by sending their information.
* Creation
    * Users can take photos to incorporate into posts.
    * Users can make 2 kinds of posts: offers and requests
* Follow-ups 
   * Users can view offers ands requests they are involved in and associated information from other users
   * Users can mark follow-ups as completed or unable to complete.
* Other Users' Profiles
    * Users can view other users' profile
* User's Received Thank-Yous (Optional)
    * Users can view all the thank yous they are tagged in. (optional)

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Post Stream
* Make a Post (Creation)
* Personal Profile
* Follow-ups

**Flow Navigation** (Screen to Screen)

* Login Screen
   * -> Home
* Registration screen
   * -> Home
* Post Stream
    * -> Individual Offer detail view
    * -> Individual Request detail view
    * -> Individual Thank you detail view (optional)
* Creation Screen
    * -> Home, after finishing post creation
    * -> Possibly photo gallery or camera to attach photo
* Personal Profile Screen
    * -> Login screen (if user logs out)
    * -> Thank-Yous received (optional)
        * -> Individual Thank-You detail view
    * -> Photo gallery/camera to change profile picture
    * -> Possibly a screen to change personal preferences
    * -> Possibly a map marking places they have sent to and received from
* Follow-ups screen
    * -> Individual Offer detail view
    * -> Individual Request detail view
* Other Users' Profile Screen

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/gg0pNU8.png" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
### Models
#### Post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| post author |
   | type          | String   | type of post (offer/request/thank you) |
   | image         | File     | image that user attaches to post |
   | bodyText      | String   | body text of user's post |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
| likesCount       | Number   | number of likes for the post (optional) |
| respondees | array of Users | users that have responded to the post |
| offerLimit | Number | max number of responses allowed, only applies to posts of type Offer (optional) |
| taggedUsers | array of Users | if post is a thank-you, the users that were thanked (optional)|
| open | Boolean | marks whether an offer/request is open or closed (optional) |
| offerRegion | String | if an offer, the region (e.g. USA, UK, or WW) author is willing to send to (optional) |


#### User
| Property | Type     | Description |
| -------- | -------- | -------- |
| objectId      | String   | unique id for the user post (default field) |
| username | String | user's chosen username (default field)|
| password | String | user's chosen password (default field)|
| createdAt     | DateTime | date when post is created (default field) |
| updatedAt     | DateTime | date when post is last updated (default field) |
| emailVerified | Boolean | whether or not user has verified email (default field) |
| email | String | user's associated email (default field) |
| aboutMeText | String| user's profile description |
| profileImage | File | user's profile image |
| followUps | Array of Posts | array of Posts that user should follow up on |
| thankYous | Array of Posts | array of thank-you posts that this user has been tagged in (optional) |
| address | String | user's mailing address |
| infoRequests | Array of InfoRequests | requests for information from other users |
| country | String | user's country (could be pulled from address) (optional)|

#### InfoRequest
| Property | Type     | Description |
| -------- | -------- | -------- |
| requestingUser | pointer to User| user who requested info|
| associatedPost | pointer to Post | post that user requested from |
| requestedUser |pointer to User | user whose info is being requested|
   

### Networking
* Login
    * (Read/GET) Log in existing User object
    ```objective-c
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
        }
    }];
    ```
* Registration
    * (Create/POST) Create new User object
    ```objective-c
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
    ```
* Profile
   * (Create/POST) Log out current logged-in User
   * (Update/PUT) Change user's profile image
   * (Update/PUT) Change user's About Me
   * (Update/PUT) Change user's address
   ``objective-c
   PFQuery *query = [PFQuery queryWithClassName:@"User"];
   
    //Retrieve the object by id
    [query getObjectInBackgroundWithId:@"fAkEiD"
                                 block:^(PFObject *user, NSError *error) {
       // Update the object's address field                          
       user[@"address"] = @"123 Main Street, Menlo Park, CA 12345";
        [gameScore saveInBackground];
    }];
   ```
* Post Stream of all 3 kinds of posts
    * (Read/GET) Query all Posts
    ```objective-c
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Successfully retrieved posts");
            // TODO: Do something with posts
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    ```
    * (Read/GET) Query Posts by type (optional)
    * (Read/GET) Query Posts by offerRegion (optional)
* Requests - details screen
    * (Create/POST) Create new InfoRequest and add it (Update/PUT) to Request author's infoRequests array
* Offers - details screen
    * (Update/PUT) Add user who clicked to respondees array for this post
* Creation
    * (Create/POST) Create new Post object
    ```objective-c
    Post *newPost = [Post new];
    newPost.author = [PFUser currentUser];
    
    [newPost saveInBackgroundWithBlock: completion];
    ```
* Follow-ups
    * (Update/PUT) Users can approve an InfoRequest to add approving user's associated request to the info requester's follow-ups
    * (Update/PUT) Remove approved or denied InfoRequest from user's infoRequests array
   * (Update/PUT) Remove Post from user's followUps array upon completion/unable to complete
 * User's Received Thank Yous (optional)
    * (No network requests needed)
- [OPTIONAL: List endpoints if using existing API such as Yelp]

## SDKs and Dependencies
### SDKs
* Google Maps SDK or another maps SDK is likely

### Dependencies
* [Parse](https://github.com/parse-community/Parse-SDK-iOS-OSX)
