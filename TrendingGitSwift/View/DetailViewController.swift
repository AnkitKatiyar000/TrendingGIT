//
//  DetailViewController.swift
//  TrendingGitSwift
//
//  Created by Vinove on 27/10/16.
//  Copyright © 2016 Vinove. All rights reserved.
//

import UIKit
import AFNetworking
import SDWebImage

class DetailViewController: UIViewController {
        
    var   projectData:Project!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forksButton: UIButton!
    @IBOutlet weak var starsButton: UIButton!
    @IBOutlet weak var readMeLabel: UILabel!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title=self.projectData.projectName
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.userImage.layer.cornerRadius=self.userImage.frame.size.width/2
        self.userImage.layoutIfNeeded()
        self.userImage.layer.masksToBounds = true
        
    }
    
    // MARK: - Custom Methods
    
    func setup() -> Void {
        
        // saet UI
        self.setButtonLayout(sender: starsButton)
        self.setButtonLayout(sender: forksButton)
        
        
        // setup data
        self.userImage.sd_setImage(with:  URL(string:self.projectData.developerImage), placeholderImage: UIImage(named:"userImage"))
        
        self.nameLabel.text=self.projectData.developerName
        self.descriptionLabel.text=self.projectData.developerDescription
        starsButton.setTitle(String(format: "%d Stars",self.projectData.stars), for: UIControlState.normal)
        
        forksButton.setTitle(String(format: "%d Forks",self.projectData.forks), for: UIControlState.normal)
        
        
        // readme content
        DispatchQueue.global(qos: .background).async {
            let data = NSData(contentsOf: NSURL(string: "https://raw.githubusercontent.com/\(self.projectData.fullName)/master/README.md")! as URL)
            DispatchQueue.main.async {
                if (data != nil){
                    let datastring = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)! as NSString
                    self.readMeLabel.text = datastring as String
                }
                
            }
        }
        
    }
    
    
    func setButtonLayout(sender:UIButton) -> Void {
        sender.layer.borderColor = UIColor(red: 96.0/255.0, green: 125.0/255.0, blue: 139.0/255.0, alpha: 1.0).cgColor
        sender.layer.borderWidth=1
        sender.layer.cornerRadius=3
        sender.layer.masksToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
