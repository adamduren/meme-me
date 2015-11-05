//
//  MemeCollectionViewController.swift
//  Meme Me
//
//  Created by Adam Duren on 11/5/15.
//  Copyright © 2015 Adam Duren. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    let cellReuseIdentifier = "MemeCollectionCell";
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    };
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.row]
        cell.imageView.image = meme.memedImage
        
        return cell;
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print("here")
        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailViewController
        
        detailVC.meme = memes[indexPath.row]
        
        self.navigationController!.pushViewController(detailVC, animated: true)
    }

    
}
