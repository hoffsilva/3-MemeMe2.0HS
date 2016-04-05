//
//  SentMemesCollectionViewController.swift
//  Meme Me 2.0
//
//  Created by Hoff Henry Pereira da Silva on 30/09/15.
//  Copyright © 2015 Hoff Henry Pereira da Silva. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
     var sentMemes: [Meme]!

    @IBOutlet weak var newPicAction: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space : CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension*1.5)
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "save", name: "save", object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        sentMemes = appDel.memes
        collectionView!.reloadData()
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentMemes.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func newPicButton(sender: AnyObject) {
        
        let newPic = storyboard?.instantiateViewControllerWithIdentifier("makeMemeViewController") as! MakeMemeViewController
        presentViewController(newPic, animated: true, completion: nil)
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellId = "memeCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = sentMemes[indexPath.item]
        let imageView = UIImageView(image: meme.memedImagem)
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailMemedImage"{
            
            let indexPaths = collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as! NSIndexPath
            let detailMemedImage: MemeDetailViewController = segue.destinationViewController as! MemeDetailViewController
            detailMemedImage.memed =  sentMemes[indexPath.row]
            
        }
    }

}
