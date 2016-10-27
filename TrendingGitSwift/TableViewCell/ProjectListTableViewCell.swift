//
//  ProjectListTableViewCell.swift
//  TrendingGitSwift
//
//  Created by Vinove on 27/10/16.
//  Copyright © 2016 Vinove. All rights reserved.
//

import UIKit

class ProjectListTableViewCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setProjectData(model: AnyObject) {
        let project = model as! Project
        self.descLabel.text = project.projectDescription
        self.starsLabel.text = String(format: "Stars :  %d",project.stars)
        self.nameLabel.text = project.projectName
    }
}
