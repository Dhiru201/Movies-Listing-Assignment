//
//  AddCommentTableViewCell.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import UIKit

class AddCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet private weak var commentViewTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentTextView.layer.cornerRadius = 4
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.borderWidth = 0.5
    }

}
