//
//  AuthViewController.swift
//  VKNews
//
//  Created by Кирилл Медведев on 24.10.2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authService = AppDelegate.shared().authService
    }
    
    @IBAction func signInTouch() {
        
        authService.wakeUpSession()
        
    }
    
}
