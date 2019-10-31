//
//  NewsfeedPresenter.swift
//  VKNews
//
//  Created by Кирилл Медведев on 26.10.2019.
//  Copyright (c) 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
  func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    
    weak var viewController: NewsfeedDisplayLogic?
    var cellLayoutCalculator: NewsfeedCellLayoutCalculatorProtocol = NewsfeedCellLayoutCalculator()
    
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        
        switch response {
            
        case .presentNewsfeed(let feed, let revealedPostIds):
            
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPostIds: revealedPostIds)
            }
            
            let feedViewModel = FeedViewModel.init(cells: cells)
            
            viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
            
        case .presentUserInfo(let user):
            let userViewModel = UserViewModel.init(firstName: user?.firstName, lastName: user?.lastName, photoUrlString: user?.photo100)
            viewController?.displayData(viewModel: .displayUser(userViewModel: userViewModel))
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        
        let isFullSized = revealedPostIds.contains { (postId) -> Bool in
            return postId == feedItem.postId
        }
        
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSizedPost: isFullSized)
        
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")
        
        return FeedViewModel.Cell.init(postId: feedItem.postId, iconUrlString: profile.photo,
                                             name: profile.name,
                                             date: dateTitle,
                                             text: postText,
                                             likes: formattedCounter(feedItem.likes?.count),
                                             comments: formattedCounter(feedItem.comments?.count),
                                             shares: formattedCounter(feedItem.reposts?.count),
                                             views: formattedCounter(feedItem.views?.count),
                                             photoAttachments: photoAttachments,
                                             sizes: sizes)
          }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil}
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
            
        }
        return counterString
        
    }
    
    private func profile(for sourceID: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {
        let profilesOrGroups: [ProfileRepresentable] = sourceID >= 0 ? profiles : groups
        let normalSourceID = sourceID >= 0 ? sourceID : -sourceID
        let profileRepresentable = profilesOrGroups.first { (myProfileRepresentable) -> Bool in
            myProfileRepresentable.id == normalSourceID
        }
        return profileRepresentable!
    }
    
    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ (attachment) in
            attachment.photo }), let firstPhoto = photos.first else { return nil}
        return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: firstPhoto.srcBIG, width: firstPhoto.width, height: firstPhoto.heihgt)
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap { (attachment) -> FeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachment.photo else { return nil}
            
            return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: photo.srcBIG,
                                                              width: photo.width,
                                                              height: photo.heihgt)
        }
    }
}
