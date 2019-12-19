//
//  FavoritesViewController.swift
//  BigThings
//
//  Created by 张珂 on 27/11/19.
//  Copyright © 2019 Ke Zhang. All rights reserved.
//

import Foundation
import UIKit
class FavoritesViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    let dataManager = SingletonManager.dataManager
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    
    func configureCollectionView(){
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView!.reloadData()
    }
    //move to the favorite big thing's detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        let detailView = (segue.destination as! UINavigationController).topViewController as! BigThingViewController
        let bigThing = dataManager.favorites[indexPath!.row]
        detailView.aBigThing = bigThing
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.favorites.count
    }
    // show the "Cell" to show the big thing
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.cellImageView.image = dataManager.favorites[indexPath.row].image
        cell.cellLabel.text = dataManager.favorites[indexPath.row].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}
