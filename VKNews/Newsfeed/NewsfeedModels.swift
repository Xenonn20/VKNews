//
//  NewsfeedModels.swift
//  VKNews
//
//  Created by Кирилл Медведев on 26.10.2019.
//  Copyright (c) 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

enum Newsfeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsfeed
        case getUser
        case revealPostIds(postId: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsfeed(feed: FeedResponse, revealedPostIds: [Int])
        case presentUserInfo(user:UserResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsfeed(feedViewModel: FeedViewModel)
        case displayUser(userViewModel: UserViewModel)
      }
    }
  }
}

struct UserViewModel: TitileViewViewModel {
    var firstName: String?
    var lastName: String?
    var photoUrlString: String?
    
}

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var postId: Int
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachments: [FeedCellPhotoAttachmentViewModel]
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoUrlString: String
        var width: Int
        var height: Int
        
        
    }
    let cells: [Cell]
}
