//
//  Review.swift
//  GoogleMapTrial1
//
//  Created by Khaled Elfakharany on 5/19/17.
//  Copyright © 2017 Khaled Elfakharany. All rights reserved.
//

import Foundation

class Review {
    private var _text : String!
    private var _userName: String!
    private var _userImageURL: String!
    private var _rating: String!
    private var _date: String!
    
    var text : String {
        get {
            if _text == nil {
                _text = ""
            }
            return _text
        }set {
            _text = newValue
        }
    }
    var userName : String {
        get {
            if _userName == nil {
                _userName = ""
            }
            return _userName
        }set {
            _userName = newValue
        }
    }
    var userImageURL : String {
        get {
            if _userImageURL == nil {
                _userImageURL = ""
            }
            return _userImageURL
        }set {
            _userImageURL = newValue
        }
    }
    var rating : String {
        get {
            if _rating == nil {
                _rating = ""
            }
            return _rating
        }set {
            _rating = newValue
        }
    }
    var date : String {
        get {
            if _date == nil {
                _date = ""
            }
            return _date
        }set {
            _date = newValue
        }
    }
}
