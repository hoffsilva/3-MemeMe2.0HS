//
//  SentMemesTableViewController.swift
//  Meme Me 2.0
//
//  Created by Hoff Henry Pereira da Silva on 13/10/15.
//  Copyright © 2015 Hoff Henry Pereira da Silva. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sentMemes: [Meme]!
    
    
    @IBOutlet weak var cancelEdit: UIBarButtonItem!
   
    @IBOutlet weak var edit: UIBarButtonItem!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var sentMemesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        sentMemes = appDel.memes
        sentMemesTableView.reloadData()
        enableEdit()
    }

    @IBAction func editButton(sender: AnyObject) {
        sentMemesTableView.editing = true
        cancelEdit.enabled  = true
        edit.enabled = false
    }
    
    
    @IBAction func cancelEditAction(sender: AnyObject) {
        sentMemesTableView.editing = false
        cancelEdit.enabled  = false
        edit.enabled = true
    }
    
    
    @IBAction func newPicButton(sender: AnyObject) {
        
        let newPic = storyboard?.instantiateViewControllerWithIdentifier("makeMemeViewController") as! MakeMemeViewController
        presentViewController(newPic, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentMemes.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "sentMemes"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell!
        let match = sentMemes[indexPath.row]
        cell.imageView?.image = match.memedImagem
        cell.textLabel!.text = "\(match.top) \(match.bottom)"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailMemedImage"{
            
            let detailMemedImage: MemeDetailViewController = segue.destinationViewController as! MemeDetailViewController
            let indexPath = sentMemesTableView.indexPathForSelectedRow!
            detailMemedImage.memed =  sentMemes[indexPath.row]
            
        }
    }

    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    @available(iOS 8.0, *)
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let buttonDeleteMemed = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) -> Void in
            self.deleteMemedImage(indexPath.row)
        }
        buttonDeleteMemed.backgroundColor = UIColor.redColor()
        return [buttonDeleteMemed]
    }
    
    func enableEdit(){
        if sentMemes.count == 0{
            edit.enabled = false
        }else {
            edit.enabled = true
        }
    }
    
    
    func deleteMemedImage(position:Int){
        appDel.memes.removeAtIndex(position)
        sentMemes.removeAtIndex(position)
        cancelEditAction(cancelEdit)
        sentMemesTableView.reloadData()
        enableEdit()
    }

}
