//
//  BigThingsViewController.swift
//  BigThings
//
//  Created by 张珂 on 24/11/19.
//  Copyright © 2019 Ke Zhang. All rights reserved.
//

import Foundation
import UIKit

class BigThingsViewController: DetailViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //for data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.bigThings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        // Set the image in the cell
        cell.cellImageView.image = dataManager.bigThings[indexPath.row].image
        
        // Set the text in the cell
        cell.cellLabel.text = dataManager.bigThings[indexPath.row].name
        
        // Return the cell
        return cell
    }
    
    let dataManager = SingletonManager.dataManager
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    func configureCollectionView() {
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
    // show detail page for the big thing you clicked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        let detailView = (segue.destination as! UINavigationController).topViewController as! BigThingViewController
        
        let singleBigThing = dataManager.bigThings[indexPath!.row]
        detailView.aBigThing = singleBigThing
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}

