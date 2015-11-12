//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Adam Duren on 11/3/15.
//  Copyright © 2015 Adam Duren. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    var appDelegate: AppDelegate!;
    var memes: [Meme] {
        return appDelegate.memes
    };
    let cellReuseIdentifier = "MemeTableCell";
    
    override func viewDidLoad() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memedImage

        return cell!;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "TableToDetailSegue") {
            let detailVC = segue.destinationViewController as! MemeDetailViewController
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)!
            
            detailVC.meme = memes[indexPath.row]
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var memesCopy = memes;
        memesCopy.removeAtIndex(indexPath.row)
        appDelegate.memes = memesCopy
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.reloadData()
    }
    
    
}