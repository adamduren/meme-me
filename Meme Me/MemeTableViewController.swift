//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Adam Duren on 11/3/15.
//  Copyright © 2015 Adam Duren. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    };
    let cellReuseIdentifier = "MemeCell";
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!;
        let meme = memes[indexPath.row];
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText;
        cell.imageView?.image = meme.memedImage;
        
        return cell!;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("here")
        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailViewController
        
        detailVC.meme = memes[indexPath.row]
        
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
}