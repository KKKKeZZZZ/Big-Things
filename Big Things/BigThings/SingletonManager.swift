//
//  SingletonManager.swift
//  BigThings
//
//  Created by 张珂 on 24/11/19.
//  Copyright © 2019 Ke Zhang. All rights reserved.
//
//singleton pattern to create a data manager that store all the thing we need through the whole project
import Foundation
class SingletonManager{
    static let dataManager = DataManager()
}
