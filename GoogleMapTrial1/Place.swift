//
//  Place.swift
//  GoogleMapTrial1
//
//  Created by Khaled Elfakharany on 5/18/17.
//  Copyright © 2017 Khaled Elfakharany. All rights reserved.
//

import Foundation

class Place {
    private var _name : String!
    private var _address: String!
    private var _address2: String!
    private var _phone: String!
    private var _rating: String!
    private var _category: String!
    private var _state: String!
    private var _imageURL: String!
    private var _reviewCount: String!
    private var _id: String!
    private var _long: Double!
    private var _lat: Double!
    
    var name : String{
        get {
            if _name == nil {
                _name = ""
            }
            return _name
        }set {
            _name = newValue
        }
    }
    var address : String{
        get {
            if _address == nil {
                _address = ""
            }
            return _address
        }set {
            _address = newValue
        }
    }
    var address2 : String{
        get {
            if _address2 == nil {
                _address2 = ""
            }
            return _address2
        }set {
            _address2 = newValue
        }
    }
    var phone : String{
        get {
            if _phone == nil {
                _phone = ""
            }
            return _phone
        }set {
            _phone = newValue
        }
    }
    var rating : String{
        get {
            if _rating == nil {
                _rating = ""
            }
            return _rating
        }set {
            _rating = newValue
        }
    }
    var category : String{
        get {
            if _category == nil {
                _category = ""
            }
            return _category
        }set {
            _category = newValue
        }
    }
    var state : String{
        get {
            if _state == nil {
                _state = ""
            }
            return _state
        }set {
            _state = newValue
        }
    }
    var imageURL : String{
        get {
            if _imageURL == nil {
                _imageURL = ""
            }
            return _imageURL
        }set {
            _imageURL = newValue
        }
    }
    var reviewCount : String{
        get {
            if _reviewCount == nil {
                _reviewCount = ""
            }
            return _reviewCount
        }set {
            _reviewCount = newValue
        }
    }
    var id : String{
        get {
            if _id == nil {
                _id = ""
            }
            return _id
        }set {
            _id = newValue
        }
    }
    var long : Double{
        get {
            if _long == nil {
                _long = 0
            }
            return _long
        }set {
            _long = newValue
        }
    }

    var lat : Double{
        get {
            if _lat == nil {
                _lat = 0
            }
            return _lat
        }set {
            _lat = newValue
        }
    }
    
    
}
