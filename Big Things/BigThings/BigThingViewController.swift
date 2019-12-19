//
//  BigThingViewController.swift
//  BigThings
//
//  Created by 张珂 on 24/11/19.
//  Copyright © 2019 Ke Zhang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
class BigThingViewController: DetailViewController{
    let dataManager = SingletonManager.dataManager
    
    
    @IBOutlet weak var bigThingImage: UIImageView!
    @IBOutlet weak var bigThingTitle: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var bigThingDescription: UILabel!
    @IBOutlet weak var bigThingLocation: UILabel!
    @IBOutlet weak var bigThingYear: UILabel!
    @IBOutlet weak var bigThingRate: UILabel!
    @IBOutlet weak var bigThingRateSlider: UISlider!
    // single big thing
    var aBigThing: BigThing?{
        didSet{
            
        }
    }
    //favorite buttton set
    func setFavoriteButton(){
        favoriteButton.setTitle("Like", for: UIControl.State())
        //if already favorited, change shown text
        if (self.aBigThing!.favorite){
            favoriteButton.setTitle("Unlike", for: UIControl.State())
        }
    }
    // for selected big thing
    override func configureView() {
        if let bigThing = self.aBigThing{
            self.bigThingImage.image = bigThing.image
            self.bigThingTitle.text = bigThing.name
            self.bigThingDescription.text = bigThing.descriptions
            self.bigThingLocation.text = bigThing.location
            self.bigThingYear.text = bigThing.year
            self.bigThingRate.text = bigThing.rating
            self.setFavoriteButton()
        }
    }
    //load it!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // how this big thing will be marked as favorited
    @IBAction func favoriteSelected(_ sender: UIButton) {
        if (self.aBigThing!.favorite){
            self.aBigThing!.favorite = false
        }
        else{
            self.aBigThing!.favorite = true
        }
        //change its favorite attribute
        self.dataManager.updateBigThing(self.aBigThing)
        self.setFavoriteButton()
        
    }
    
    
    // rating function
    @IBAction func rateBigThing(_ sender: UIButton) {
        //get slider's rating value
        let rateValue = NSString(format:"%.2f", self.bigThingRateSlider.value) as String
        // show user's rating
        self.bigThingRate.text = rateValue
        aBigThing?.rating = rateValue
    }
    
    func displayMap()
    {
        // lati and longi attributes
        let bigLatitude: CLLocationDegrees = (aBigThing?.latitude as! NSString).doubleValue
        let bigLongitude: CLLocationDegrees = (aBigThing?.longitude as! NSString).doubleValue
        let regionDistance:CLLocationDistance = 10000
        //coordinator creating
        let bigCoordinate = CLLocationCoordinate2DMake(bigLatitude, bigLongitude)
        let regionSpan = MKCoordinateRegion(center: bigCoordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: bigCoordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        //location name show in the map
        mapItem.name = aBigThing?.name
        //open the location in the map
        mapItem.openInMaps(launchOptions: options)
    }
    //location button
    @IBAction func showLocation(_ sender: UIButton) {
        self.displayMap()
    }
    
}
