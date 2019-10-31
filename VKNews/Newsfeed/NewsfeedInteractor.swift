//
//  NewsfeedInteractor.swift
//  VKNews
//
//  Created by Кирилл Медведев on 26.10.2019.
//  Copyright (c) 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
  func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {

  var presenter: NewsfeedPresentationLogic?
  var service: NewsfeedService?
  
  func makeRequest(request: Newsfeed.Model.Request.RequestType) {
    if service == nil {
      service = NewsfeedService()
    }
  }
  
}
