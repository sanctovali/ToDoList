//
//  TaskCell.swift
//  ToDoList
//
//  Created by Valentin Kiselev on 23/01/2019.
//  Copyright © 2019 Valentin Kiselev. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

	@IBOutlet weak var taskImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
		taskImageView.layer.cornerRadius = taskImageView.frame.size.height / 2
		taskImageView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
