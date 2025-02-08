//
//  ProfileViewController.swift
//  ImageFeedExtend
//
//  Created by Nadin on 07.02.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func exitButtonTap(_ sender: Any) {
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()           
           setupProfile()
       }

       private func setupProfile() {
           nameLabel.text = "Екатерина Новикова"
           usernameLabel.text = "@ekaterina_nov"
           statusLabel.text = "Hello, world!"
           profileImage.layer.cornerRadius = profileImage.frame.width / 2
           profileImage.clipsToBounds = true
       }
}
