//
//  reviewTableCell.swift
//  GoogleMapTrial1
//
//  Created by Khaled Elfakharany on 5/19/17.
//  Copyright © 2017 Khaled Elfakharany. All rights reserved.
//

import UIKit

class reviewTableCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var userComment: UITextView!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(review : Review){
        userName.text = review.userName
        ratingImage.image = UIImage(named: review.rating)
        if review.rating == "4.5" {
            ratingImage.image = UIImage(named: "45")
        }
        if review.rating == "3.5" {
            ratingImage.image = UIImage(named: "35")
        }
        if review.rating == "2.5" {
            ratingImage.image = UIImage(named: "25")
        }
        if review.rating == "1.5" {
            ratingImage.image = UIImage(named: "15")
        }
        if review.rating == "0.5" {
            ratingImage.image = UIImage(named: "05")
        }
        userComment.text = review.text
        date.text = review.date
        let url = URL(string: review.userImageURL)!
        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.global().sync {
                self.userImage.image = UIImage(data: data)
            }
        }catch{
            
        }
    }
}
