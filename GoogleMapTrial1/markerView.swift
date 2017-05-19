//
//  markerView.swift
//  GoogleMapTrial1
//
//  Created by Khaled Elfakharany on 5/19/17.
//  Copyright © 2017 Khaled Elfakharany. All rights reserved.
//

import UIKit
import YelpAPI
import BrightFutures

class markerView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var place = Place()
    let appId = "q63Cg4PkPST1DGuumIFkrg"
    let appSecret = "zV2guR6QyCJVS3X7sYdSRJoBkFTHHKtXIqTGTyF3HthkUEWxlwxHEGudF9hPXDKg"
    var reviews = [Review]()
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var numberOfReviewLbl: UILabel!
    @IBOutlet weak var reviewTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = place.name
        ratingLbl.text = place.rating
        ratingImage.image = UIImage(named: place.rating)
        if place.rating == "4.5" {
            ratingImage.image = UIImage(named: "45")
        }
        if place.rating == "3.5" {
            ratingImage.image = UIImage(named: "35")
        }
        if place.rating == "2.5" {
            ratingImage.image = UIImage(named: "25")
        }
        if place.rating == "1.5" {
            ratingImage.image = UIImage(named: "15")
        }
        if place.rating == "0.5" {
            ratingImage.image = UIImage(named: "05")
        }
        categoryLbl.text = place.category
        stateLbl.text = place.state
        phoneLbl.text = place.phone
        numberOfReviewLbl.text = place.reviewCount
        let url = URL(string: place.imageURL)!
        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.global().sync {
                self.image.image = UIImage(data: data)
            }
        }catch{
            
        }
        reviewTable.delegate = self
        reviewTable.dataSource = self
        downloadReviews {
            self.refreshUI()
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableCell", for: indexPath) as? reviewTableCell {
            
            let review = reviews[indexPath.row]
            
            cell.updateUI(review: review)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    
    func downloadReviews(completed: @escaping ()->()){
        YLPClient.authorize(withAppId: appId, secret: appSecret) { (client,error) in
            if error == nil {
                client?.reviewsForBusiness(withId: self.place.id){ (review,error) in
                    for item in (review?.reviews)! {
                        let review = Review()
                        review.text = item.excerpt
                        review.rating = "\(item.rating)"
                        review.userName = item.user.name
                        if let imageURL = item.user.imageURL {
                            review.userImageURL = "\(imageURL)"
                        }
                        review.date = "\(item.timeCreated)"
                        self.reviews.append(review)
                    }
                    completed()
                    
                    
                }
            }
        }
    }
    func refreshUI() {
        DispatchQueue.main.async(execute: {
            self.reviewTable.reloadData()
        })
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
