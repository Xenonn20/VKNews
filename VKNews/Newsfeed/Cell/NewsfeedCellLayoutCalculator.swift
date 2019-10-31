//
//  NewsfeedCellLayoutCalculator.swift
//  VKNews
//
//  Created by Кирилл Медведев on 27.10.2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

protocol NewsfeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
    
}

final class NewsfeedCellLayoutCalculator: NewsfeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes {
        
        var showMoreTextButton = false
        
        let cardView = screenWidth - Constants.cardInsets.left - Constants.cardInsets.right
        
        // MARK: - Work with postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top
        ), size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardView - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            var height = text.height(width: width, font: Constants.postLabelFont)
            
            let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
            
            if !isFullSizedPost && height > limitHeight {
                height = Constants.postLabelFont.lineHeight * Constants.minifiedPostLines
                showMoreTextButton = true
            }
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        // MARK: - Work with moreTextButtonFrame
        
        var moreTextButtonSize = CGSize.zero
        
        if showMoreTextButton {
            moreTextButtonSize = Constants.moreTextButtonSize
        }
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        // MARK: - Work with attachmentFrame
        
        let attachmentsTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : moreTextButtonFrame.maxY + Constants.postLabelInsets.bottom
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentsTop), size: CGSize.zero)
        
//        if let attachment = photoAttachment {
//            let photoHeight: Float = Float(attachment.height)
//            let photoWidth: Float = Float(attachment.width)
//            let ratio = CGFloat( photoHeight / photoWidth)
//            attachmentFrame.size = CGSize(width: cardView, height: ratio * cardView)
//        }
        
        if let attachment = photoAttachments.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat( photoHeight / photoWidth)
            
            if photoAttachments.count == 1 {
                attachmentFrame.size = CGSize(width: cardView, height: ratio * cardView)
            } else if photoAttachments.count > 1 {
                
                var photos = [CGSize]()
                for photo in photoAttachments {
                    let photoSize = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
                    photos.append(photoSize)
                }
                let rowHeight = RowLayout.rowHeightCounter(superviewWidth: cardView, photosArray: photos)
                attachmentFrame.size = CGSize(width: cardView, height: rowHeight!)
            }
        }
        
        // MARK: - Work with bottomViewFrame
        
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardView, height: Constants.bottomViewHeight))
        
        // MARK: - Work with totalHeight
        
        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom
        
        return Sizes(postLabelFrame: postLabelFrame, moreTextButtonFrame: moreTextButtonFrame, attachmentFrame: attachmentFrame, bottomViewFrame: bottomViewFrame, totalHeight: totalHeight)
    }
    
}
