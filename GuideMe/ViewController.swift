//
//  ViewController.swift
//  FirstScreen
//
//  Created by student on 3/5/16.
//  Copyright © 2016 Vishnu S R. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBAction func startNavigating(sender: AnyObject) {
        
      
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("newViewController") as! UINavigationController
        
        self.presentViewController(nvc, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

