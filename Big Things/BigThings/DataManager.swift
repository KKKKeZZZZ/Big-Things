//
//  DataManager.swift
//  BigThings
//
//  Created by 张珂 on 24/11/19.
//  Copyright © 2019 Ke Zhang. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DataManager{
    //core data element
    var segueArray = [String]()
    var segueDictionary = Dictionary<String, UIImage>()
    
    var bigThings = [BigThing]()
    var storeBigThings = [NSManagedObject]()
    
    init(){
        //navigation page array
        segueArray.append("Home")
        segueArray.append("BigThings")
        segueArray.append("Favorites")
        //
        segueDictionary["Home"] = UIImage(named: "home")
        segueDictionary["BigThings"] = UIImage(named: "menu")
        segueDictionary["Favorites"] = UIImage(named: "menu")
        self.getBigThings()
        self.loadBigThings()

    }
    // favorites big thing container
    var favorites: [BigThing]{
        get{
            var selectedBigThings = [BigThing]()
            if(bigThings.count > 0){
                for count in 0...bigThings.count - 1{
                    if bigThings[count].favorite{
                        selectedBigThings.append(bigThings[count])
                    }
                }
            }
            return selectedBigThings
        }
    }
    //api reader, write to core data
    func getBigThings(){
        //url for web database
        let url = NSURL(string: "https://partiklezoo.com/bigthings/")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url! as URL, completionHandler: {
            (data, response, error) in
            if (error != nil) {return;}
            if let json = try? JSON(data: data!){
                if json.count > 0{
                    for count in 0...json.count - 1{
                        let jsonBigThing = json[count]
                        //new big thing instanse
                        let newBigThing = BigThing(id: jsonBigThing["id"].string!, name: jsonBigThing["name"].string!, location: jsonBigThing["location"].string!, year: jsonBigThing["year"].string!, status: jsonBigThing["status"].string!, latitude: jsonBigThing["latitude"].string!, longitude: jsonBigThing["longitude"].string!,rating: jsonBigThing["rating"].string!, votes: jsonBigThing["votes"].string!, descriptions: jsonBigThing["description"].string!)
                        let imageURLString = "https://partiklezoo.com/bigthings/images/" + jsonBigThing["image"].string!
                        self.addItemToBigThings(newBigThing, imageURL: imageURLString)
                        
                    }
                }
            }
        })
        task.resume()
    }
    //load the big thing from core data
    func loadBigThings(){
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BigThings")
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            storeBigThings = results as! [NSManagedObject]
            if (storeBigThings.count > 0){
                for index in 0...storeBigThings.count - 1{
                    let id = storeBigThings[index].value(forKey:"id") as! String
                    let name = storeBigThings[index].value(forKey:"name") as! String
                    let location = storeBigThings[index].value(forKey:"location") as! String
                    let year = storeBigThings[index].value(forKey:"year") as! String
                    let status = storeBigThings[index].value(forKey:"status") as! String
                    let latitude = storeBigThings[index].value(forKey:"latitude") as! String
                    let longitude = storeBigThings[index].value(forKey:"longitude") as! String
                    let binaryData = storeBigThings[index].value(forKey: "image") as! Data
                    let image = UIImage(data: binaryData)
                    let rating = storeBigThings[index].value(forKey:"rating") as! String
                    let votes = storeBigThings[index].value(forKey:"votes") as! String
                    let descriptions = storeBigThings[index].value(forKey:"descriptions") as! String
                    _ = storeBigThings[index].value(forKey:"favorite") as! Any
                    // big thing instance
                    let loadBigThing = BigThing(id: id, name: name, location: location, year: year, status: status, latitude: latitude, longitude: longitude, image: image!, rating: rating, votes: votes, descriptions: descriptions)
                    bigThings.append(loadBigThing)
                }
            }
        }
        catch let error as NSError{
            print("Cloud not load. \(error), \(error.userInfo)")
        }
    }
    // if the big thing is already exist
    func checkForBigThing(_ searchItem: BigThing) -> Int{
        var targetIndex = -1
        if (bigThings.count > 0){
            for index in 0...bigThings.count - 1{
                if bigThings[index].id.isEqual(searchItem.id){
                    targetIndex = index
                }
            }
        }
        return targetIndex
    }
    //bind the image to the big thing
    func addItemToBigThings(_ newBigThing: BigThing!, imageURL: String){
        if checkForBigThing(newBigThing) == -1{
            DispatchQueue.main.async (execute:{
                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                newBigThing.image = self.loadImage(imageURL)
                let entity = NSEntityDescription.entity(forEntityName: "BigThings", in: managedContext)
                
                let bigTingToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
                bigTingToAdd.setValue(newBigThing.id, forKey: "id")
                bigTingToAdd.setValue(newBigThing.name, forKey: "name")
                bigTingToAdd.setValue(newBigThing.location, forKey: "location")
                bigTingToAdd.setValue(newBigThing.year, forKey: "year")
                bigTingToAdd.setValue(newBigThing.status, forKey: "status")
                bigTingToAdd.setValue(newBigThing.latitude, forKey: "latitude")
                bigTingToAdd.setValue(newBigThing.longitude, forKey: "longitude")
                bigTingToAdd.setValue(newBigThing.image!.pngData(), forKey: "image")
                bigTingToAdd.setValue(newBigThing.rating, forKey: "rating")
                bigTingToAdd.setValue(newBigThing.votes, forKey: "votes")
                bigTingToAdd.setValue(newBigThing.descriptions, forKey: "descriptions")
                
                do {
                    try managedContext.save()
                }
                catch let error as NSError{
                    print("Could not save. \(error), \(error.userInfo)")
                }
                self.storeBigThings.append(bigTingToAdd)
                self.bigThings.append(newBigThing)
            })
            
            
            
        }
    }
    // load image
    func loadImage(_ imageURL: String!) -> UIImage{
        var image: UIImage!
        if let url = NSURL(string: imageURL){
            if let data = NSData(contentsOf: url as URL){
                image = UIImage(data: data as Data)
            }
        }
        return image!
    }
    // refresh the list of big thing
    func updateBigThing(_ newBigThing: BigThing!){
        
    }
}
