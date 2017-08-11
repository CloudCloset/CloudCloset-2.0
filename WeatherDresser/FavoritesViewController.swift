//
//  FavoritesViewController.swift
//  WeatherDresser
//
//  Created by Lily Li on 8/10/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var picCount: Int = 0
    var arrPics = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPics()
        reloadNumPics()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getPics()
        reloadNumPics()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadNumPics() {
        let ref = Database.database().reference().child("users").child(User.current.uid).child("likePic")
        
        //let dispatchGroup = DispatchGroup()
        //dispatchGroup.enter()
        var count = 0
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            count = Int(snapshot.childrenCount)
            self.picCount = count
            self.collectionView.reloadData()
            //dispatchGroup.leave()
        })
        //dispatchGroup.notify(queue: .main, execute: {

        //})
    }
    
    func getPics() {
        arrPics = []
        var arr = [String: Bool]()
        let ref = Database.database().reference().child("users").child(User.current.uid).child("likePic")
        //let dispatchGroup = DispatchGroup()
        //dispatchGroup.enter()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let item = snapshot.value as? [String : Bool] {
                for key in item.keys {
                    arr.updateValue(true, forKey: key)
                }
                for str in arr {
                    let img = UIImage(named: str.key)!
                    self.arrPics.append(img)
                }
                self.collectionView.reloadData()
            }
            //dispatchGroup.leave()
        })
        //dispatchGroup.wait()
        //dispatchGroup.notify(queue: .main, execute: {
//            for str in arr {
//                let img = UIImage(named: str.key)!
//                self.arrPics.append(img)
//            }
//            self.collectionView.reloadData()
        //})
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //reloadNumPics()
        return self.picCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! FavoriteCollectionViewCell
        cell.thumbNailImage.image = arrPics[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "favHeaderView", for: indexPath) as! FavHeaderCollectionReusableView
        
        return headerView
    }
    
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: 190, height: 300)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}
