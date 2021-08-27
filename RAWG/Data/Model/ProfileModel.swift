//
//  ProfileModel.swift
//  RAWG
//
//  Created by Iman Faizal on 24/08/21.
//

import UIKit

struct ProfileModel {
    static let photosKey = "photos"
    static let nameKey = "name"
    static let emailKey = "email"
    
    static var photos: Data {
        get {
            return UserDefaults.standard.data(forKey: photosKey) ?? UIImage(systemName: "photo")!.pngData()!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: photosKey)
        }
    }

    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }

    static var email: String {
        get {
            return UserDefaults.standard.string(forKey: emailKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: emailKey)
        }
    }

    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
