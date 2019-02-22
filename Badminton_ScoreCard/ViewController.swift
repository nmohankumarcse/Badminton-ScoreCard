//
//  ViewController.swift
//  Badminton_ScoreCard
//
//  Created by Mohankumar on 12/09/18.
//  Copyright © 2018 Mohankumar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var redGame: UILabel!
    @IBOutlet weak var blueGame: UILabel!
    
    var blue : Int = 0
    var red : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func outerRedTouched(_ sender: Any) {
        incrementRed()
    }
    
    @IBAction func innerRedTouched(_ sender: Any) {
        incrementBlue()
    }
    
    @IBAction func outerBlueTouched(_ sender: Any) {
        incrementBlue()
    }
    
    @IBAction func innerBlueTouched(_ sender: Any) {
        incrementRed()
    }
    @IBAction func netRedtouched(_ sender: Any) {
        incrementBlue()
    }
    @IBAction func netBlueTouched(_ sender: Any) {
        incrementRed()
    }
    
    func incrementBlue(){
        blue = blue + 1
        blueGame.text = "\(blue)"
    }
    
    func incrementRed(){
        red = red + 1
        redGame.text = "\(red)"
    }
}

