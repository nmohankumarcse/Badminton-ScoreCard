//
//  ViewController.swift
//  Badminton_ScoreCard
//
//  Created by Mohankumar on 12/09/18.
//  Copyright © 2018 Mohankumar. All rights reserved.
//

import UIKit
//import Firebase

struct CurrentMatch{
    static var shared = CurrentMatch()
    var  bluePlayer1 : String = "B1"
    var  bluePlayer2 : String  = "B2"
    var  redPlayer1 : String = "R1"
    var  redPlayer2 : String = "R2"
}

enum ServedBy : String{
    case B1
    case B2
    case R1
    case R2
    
    var playerName : String{
        switch self{
        case .B1:
            return CurrentMatch.shared.bluePlayer1
        case .B2:
            return CurrentMatch.shared.bluePlayer2
        case .R1:
            return CurrentMatch.shared.redPlayer1
        case .R2:
            return CurrentMatch.shared.redPlayer2
        }
    }
    
    static func originalValue(playerName : String) -> String{
        if playerName == CurrentMatch.shared.bluePlayer1{
            return "B1"
        }
        else if playerName == CurrentMatch.shared.bluePlayer2{
            return "B2"
        }
        else if playerName == CurrentMatch.shared.redPlayer1{
            return "R1"
        }
        else{
            return "R2"
        }
    }
}

enum ConcededBy{
    case place
    case Net
    case Away
}

enum BallPlacedAt{
    case innerRed
    case outerRed
    case innerBlue
    case outerBlue
    case blueNet
    case redNet
}

enum Team{
    case Blue
    case Red
}

struct PBPoint{
    var pointNo : Int
    var servedBy : ServedBy
    var concededBy : ConcededBy
    var ballPlacedAt : BallPlacedAt
    var pointFor : Team
}



enum PlayerImageVariant{
    case serveImage
    case nonServeImage
    
    var image : UIImage{
        switch self{
        case .serveImage:
            return UIImage(systemName: "figure.badminton")!
        case .nonServeImage:
            return UIImage(systemName: "person.fill")!
            
        }
    }
}

enum EditAndCloseImageVariant{
    case edit
    case close
    
    var image : UIImage{
        switch self{
        case .edit:
            return UIImage(systemName: "highlighter")!
        case .close:
            return UIImage(systemName: "xmark")!
            
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var redGameLabel: UILabel!
    @IBOutlet weak var blueGameLabel: UILabel!
    var isGameOver : Bool = false
    
    //----
    @IBOutlet weak var playerBlueLeftTextField: UITextField!
    @IBOutlet weak var playerBlueLeftEditOrSaveButton: UIButton!
    @IBOutlet weak var playerBlueLeftLabel: UILabel!
    @IBOutlet weak var blueLeftImage: UIImageView!
    //
    
    //----
    @IBOutlet weak var playerBlueRightTextField: UITextField!
    @IBOutlet weak var playerBlueRightEditOrSaveButton: UIButton!
    @IBOutlet weak var playerBlueRightLabel: UILabel!
    @IBOutlet weak var blueRightImage: UIImageView!
    //--
    
    //----
    @IBOutlet weak var playerRedLeftTextField: UITextField!
    @IBOutlet weak var playerRedLeftEditOrSaveButton: UIButton!
    @IBOutlet weak var playerRedLeftLabel: UILabel!
    @IBOutlet weak var redLeftImage: UIImageView!
    //
    
    
    //----
    @IBOutlet weak var playerRedRightTextField: UITextField!
    @IBOutlet weak var playerRedRightEditOrSaveButton: UIButton!
    @IBOutlet weak var playerRedRightLabel: UILabel!
    @IBOutlet weak var redRightImage: UIImageView!
    //
    
    
    
    @IBOutlet weak var teamRedTextField: UITextField!
    @IBOutlet weak var teamRedLabel: UILabel!
    @IBOutlet weak var teamRedEditOrSaveButton: UIButton!
    @IBOutlet weak var teamBlueTextField: UITextField!
    @IBOutlet weak var teamBlueLabel: UILabel!
    @IBOutlet weak var teamBlueEditOrSaveButton: UIButton!
    
    var pointForBlue : Int = 0
    var pointForRed : Int = 0
    var currentServeBy : ServedBy = .B1
    var pointStack : [PBPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPressed(self)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func outerRedTouched(_ sender: Any) {
        incrementRed()
        updatePlayerPositionAndPointLabel(ballPlacedAt: .outerRed)
    }
    
    @IBAction func innerRedTouched(_ sender: Any) {
        incrementBlue()
        updatePlayerPositionAndPointLabel(ballPlacedAt: .innerRed)
    }
    
    @IBAction func outerBlueTouched(_ sender: Any) {
        incrementBlue()
        updatePlayerPositionAndPointLabel(ballPlacedAt: .outerBlue)
    }
    
    @IBAction func innerBlueTouched(_ sender: Any) {
        incrementRed()
        updatePlayerPositionAndPointLabel(ballPlacedAt: .innerBlue)
    }
    
    @IBAction func netRedtouched(_ sender: Any) {
        incrementBlue()
        updatePlayerPositionAndPointLabel(ballPlacedAt: .redNet)
    }
    
    @IBAction func netBlueTouched(_ sender: Any) {
        incrementRed()
        updatePlayerPositionAndPointLabel(ballPlacedAt: .blueNet)
    }
    
    @IBAction func teamRedEditOrSaveButtonPressed(_ sender: Any) {
        if teamRedEditOrSaveButton.image(for: .normal) == EditAndCloseImageVariant.edit.image{
            teamRedTextField.isHidden = false
            teamRedLabel.isHidden = true
            teamRedTextField.text = teamRedLabel.text
            teamRedTextField.becomeFirstResponder()
            teamRedEditOrSaveButton.setImage(EditAndCloseImageVariant.close.image, for: .normal)
        }
        else{
            teamRedTextField.isHidden = true
            teamRedLabel.isHidden = false
            teamRedLabel.text = teamRedTextField.text
            teamRedTextField.endEditing(true)
            teamRedEditOrSaveButton.setImage(EditAndCloseImageVariant.edit.image, for: .normal)
        }
    }
    
    @IBAction func teamBlueEditOrSaveButtonPressed(_ sender: Any) {
        if teamBlueEditOrSaveButton.image(for: .normal) == EditAndCloseImageVariant.edit.image{
            teamBlueTextField.isHidden = false
            teamBlueLabel.isHidden = true
            teamBlueTextField.becomeFirstResponder()
            teamBlueTextField.text = teamBlueLabel.text
            teamBlueEditOrSaveButton.setImage(EditAndCloseImageVariant.close.image, for: .normal)
        }
        else{
            teamBlueTextField.isHidden = true
            teamBlueLabel.isHidden = false
            teamBlueLabel.text = teamBlueTextField.text
            teamBlueTextField.endEditing(true)
            teamBlueEditOrSaveButton.setImage(EditAndCloseImageVariant.edit.image, for: .normal)
        }
    }
    
    @IBAction func playerRedRightEditOrSaveButtonPressed(_ sender: Any) {
        if playerRedRightEditOrSaveButton.image(for: .normal) == EditAndCloseImageVariant.edit.image{
            playerRedRightTextField.isHidden = false
            playerRedRightLabel.isHidden = true
            playerRedRightTextField.text = playerRedRightLabel.text
            playerRedRightTextField.becomeFirstResponder()
            playerRedRightEditOrSaveButton.setImage(EditAndCloseImageVariant.close.image, for: .normal)
        }
        else{
            playerRedRightTextField.isHidden = true
            playerRedRightLabel.isHidden = false
            playerRedRightLabel.text = playerRedRightTextField.text
            CurrentMatch.shared.redPlayer1 = playerRedRightTextField.text ?? ""
            playerRedRightTextField.endEditing(true)
            playerRedRightEditOrSaveButton.setImage(EditAndCloseImageVariant.edit.image, for: .normal)
        }
    }
    
    
    @IBAction func playerRedLeftEditOrSaveButtonPressed(_ sender: Any) {
        if playerRedLeftEditOrSaveButton.image(for: .normal) == EditAndCloseImageVariant.edit.image{
            playerRedLeftTextField.isHidden = false
            playerRedLeftLabel.isHidden = true
            playerRedLeftTextField.text = playerRedLeftLabel.text
            playerRedLeftTextField.becomeFirstResponder()
            playerRedLeftEditOrSaveButton.setImage(EditAndCloseImageVariant.close.image, for: .normal)
        }
        else{
            playerRedLeftTextField.isHidden = true
            playerRedLeftLabel.isHidden = false
            playerRedLeftLabel.text = playerRedLeftTextField.text
            CurrentMatch.shared.redPlayer2 = playerRedLeftTextField.text ?? ""
            playerRedLeftTextField.endEditing(true)
            playerRedLeftEditOrSaveButton.setImage(EditAndCloseImageVariant.edit.image, for: .normal)
        }
    }
    
    
    
    @IBAction func playerBlueLeftEditOrSaveButtonPressed(_ sender: Any) {
        if playerBlueLeftEditOrSaveButton.image(for: .normal) == EditAndCloseImageVariant.edit.image{
            playerBlueLeftTextField.isHidden = false
            playerBlueLeftLabel.isHidden = true
            playerBlueLeftTextField.text = playerBlueLeftLabel.text
            playerBlueLeftTextField.becomeFirstResponder()
            playerBlueLeftEditOrSaveButton.setImage(EditAndCloseImageVariant.close.image, for: .normal)
        }
        else{
            playerBlueLeftTextField.isHidden = true
            playerBlueLeftLabel.isHidden = false
            playerBlueLeftLabel.text = playerBlueLeftTextField.text
            CurrentMatch.shared.bluePlayer2 = playerBlueLeftTextField.text ?? ""
            playerBlueLeftTextField.endEditing(true)
            playerBlueLeftEditOrSaveButton.setImage(EditAndCloseImageVariant.edit.image, for: .normal)
        }
    }
    
    
    @IBAction func playerBlueRightEditOrSaveButtonPressed(_ sender: Any) {
        if playerBlueRightEditOrSaveButton.image(for: .normal) == EditAndCloseImageVariant.edit.image{
            playerBlueRightTextField.isHidden = false
            playerBlueRightLabel.isHidden = true
            playerBlueRightTextField.text = playerBlueRightLabel.text
            playerBlueRightTextField.becomeFirstResponder()
            playerBlueRightEditOrSaveButton.setImage(EditAndCloseImageVariant.close.image, for: .normal)
        }
        else{
            playerBlueRightTextField.isHidden = true
            playerBlueRightLabel.isHidden = false
            playerBlueRightLabel.text = playerBlueRightTextField.text
            CurrentMatch.shared.bluePlayer1 = playerBlueRightTextField.text ?? ""
            playerBlueRightTextField.endEditing(true)
            playerBlueRightEditOrSaveButton.setImage(EditAndCloseImageVariant.edit.image, for: .normal)
        }
    }
    
    
    func incrementBlue(){
        if !isGameOver{
            pointForBlue = pointForBlue + 1
            blueGameLabel.text = "\(pointForBlue)"
        }
        else{
            if pointForRed > pointForBlue{
                self.showAlert(message: "\(teamRedLabel.text ?? "Red") won the game \(pointForRed) - \(pointForBlue)")
            }
            else{
                self.showAlert(message: "\(teamBlueLabel.text ?? "Blue") won the game \(pointForBlue) - \(pointForRed)")
            }
        }
        if pointForBlue == 21 && pointForRed < 20{
            isGameOver = true
            self.showAlert(message: "\(teamBlueLabel.text ?? "Blue") won the game \(pointForBlue) - \(pointForRed)")
        }
        else if pointForRed > 21 && pointForBlue - pointForRed > 1{
            isGameOver = true
            self.showAlert(message: "\(teamRedLabel.text ?? "Red") won the game \(pointForBlue) - \(pointForRed)")
        }
    }
    
    func incrementRed(){
        if !isGameOver{
            pointForRed = pointForRed + 1
            redGameLabel.text = "\(pointForRed)"
        }
        else{
            if pointForBlue > pointForRed{
                self.showAlert(message: "\(teamBlueLabel.text ?? "Blue") won the game \(pointForBlue) - \(pointForRed)")
            }
            else{
                self.showAlert(message: "\(teamRedLabel.text ?? "Red") won the game \(pointForRed) - \(pointForBlue)")
            }
        }
        if pointForRed == 21 && pointForBlue < 20{
            isGameOver = true
            self.showAlert(message: "\(teamRedLabel.text ?? "Red") won the game by \(pointForRed) - \(pointForBlue)")
        }
        else if pointForBlue > 21 && pointForRed - pointForBlue > 1{
            isGameOver = true
            self.showAlert(message: "\(teamRedLabel.text ?? "Red") won the game by \(pointForRed) - \(pointForBlue)")
        }
    }
    
    fileprivate func switchPlayerInBlue() {
        playerBlueRightLabel.text = playerBlueRightLabel.text == ServedBy.B1.playerName ? ServedBy.B2.playerName : ServedBy.B1.playerName
        playerBlueLeftLabel.text = playerBlueLeftLabel.text == ServedBy.B2.playerName ? ServedBy.B1.playerName : ServedBy.B2.playerName
        if blueRightImage.image == PlayerImageVariant.serveImage.image{
            blueRightImage.image =  PlayerImageVariant.nonServeImage.image
            blueLeftImage.image =  PlayerImageVariant.serveImage.image
        }
        else{
            blueRightImage.image =  PlayerImageVariant.serveImage.image
            blueLeftImage.image =  PlayerImageVariant.nonServeImage.image
        }
        
        redRightImage.image =  PlayerImageVariant.nonServeImage.image
        redLeftImage.image =  PlayerImageVariant.nonServeImage.image
        
        if let blueRightPlayer = playerBlueRightLabel.text, let blueLeftPlayer = playerBlueLeftLabel.text{
            if blueRightImage.image == PlayerImageVariant.serveImage.image {
                currentServeBy = ServedBy(rawValue: ServedBy.originalValue(playerName: blueRightPlayer))!
            }
            else{
                currentServeBy = ServedBy(rawValue: ServedBy.originalValue(playerName: blueLeftPlayer))!
            }
        }
    }
    
    fileprivate func switchPlayerInRed() {
        playerRedLeftLabel.text = playerRedLeftLabel.text == ServedBy.R1.playerName ? ServedBy.R2.playerName : ServedBy.R1.playerName
        playerRedRightLabel.text = playerRedRightLabel.text == ServedBy.R2.playerName ? ServedBy.R1.playerName : ServedBy.R2.playerName
        
        if redRightImage.image == PlayerImageVariant.serveImage.image{
            redRightImage.image =  PlayerImageVariant.nonServeImage.image
            redLeftImage.image =  PlayerImageVariant.serveImage.image
        }
        else{
            redRightImage.image =  PlayerImageVariant.serveImage.image
            redLeftImage.image =  PlayerImageVariant.nonServeImage.image
        }
        
        blueLeftImage.image =  PlayerImageVariant.nonServeImage.image
        blueRightImage.image =  PlayerImageVariant.nonServeImage.image
        
        
        if let redRightPlayer = playerRedRightLabel.text, let redLeftPlayer = playerRedLeftLabel.text{
            if redRightImage.image == PlayerImageVariant.serveImage.image {
                currentServeBy = ServedBy(rawValue: ServedBy.originalValue(playerName: redRightPlayer))!
            }
            else{
                currentServeBy = ServedBy(rawValue: ServedBy.originalValue(playerName: redLeftPlayer))!
            }
        }
    }
    
    fileprivate func serviceCutToRed(){
        if pointForRed % 2 == 0{
            if let redRightPlayer = playerRedRightLabel.text{
                currentServeBy = ServedBy(rawValue: ServedBy.originalValue(playerName: redRightPlayer))!
                redRightImage.image = PlayerImageVariant.serveImage.image
                redLeftImage.image =  PlayerImageVariant.nonServeImage.image
            }
        }
        else{
            if let redLeftPlayer = playerRedLeftLabel.text{
                currentServeBy = ServedBy(rawValue: ServedBy.originalValue(playerName: redLeftPlayer))!
                redLeftImage.image = PlayerImageVariant.serveImage.image
                redRightImage.image =  PlayerImageVariant.nonServeImage.image
            }
        }
        blueLeftImage.image =  PlayerImageVariant.nonServeImage.image
        blueRightImage.image =  PlayerImageVariant.nonServeImage.image
    }
    
    
    fileprivate func serviceCutToBlue(){
        if pointForBlue % 2 == 0{
            if let blueRightPlayer = playerBlueRightLabel.text{
                currentServeBy = ServedBy(rawValue: ServedBy.originalValue(playerName: blueRightPlayer))!
                blueRightImage.image = PlayerImageVariant.serveImage.image
                blueLeftImage.image =  PlayerImageVariant.nonServeImage.image
            }
        }
        else{
            if let blueLeftPlayer = playerBlueLeftLabel.text{
                currentServeBy = ServedBy(rawValue: ServedBy.originalValue(playerName: blueLeftPlayer))!
                blueLeftImage.image = PlayerImageVariant.serveImage.image
                blueRightImage.image =  PlayerImageVariant.nonServeImage.image
            }
        }
        redLeftImage.image =  PlayerImageVariant.nonServeImage.image
        redRightImage.image =  PlayerImageVariant.nonServeImage.image
    }
    
    func updatePlayerPositionAndPointLabel(ballPlacedAt : BallPlacedAt){
        let servedBy : ServedBy = currentServeBy
//        let lastPoint : PBPoint? = pointStack.last
//        if let lastPointServedBy = lastPoint?.servedBy{
//
//        }
        
        switch ballPlacedAt {
        //** Points for Blue**/
        case .innerRed:
            pointStack.append(PBPoint(pointNo: pointForBlue, servedBy: servedBy, concededBy: .place, ballPlacedAt: .innerRed, pointFor: .Blue))
            if currentServeBy == .B1 || currentServeBy == .B2{
               switchPlayerInBlue()
            }
            else{
                serviceCutToBlue()
            }
            break
        case .outerBlue:
            pointStack.append(PBPoint(pointNo: pointForBlue, servedBy: servedBy, concededBy: .Away, ballPlacedAt: .outerBlue, pointFor: .Blue))
            if currentServeBy == .B1 || currentServeBy == .B2{
                switchPlayerInBlue()
            }
            else{
                serviceCutToBlue()
            }
            break
        case .redNet:
            pointStack.append(PBPoint(pointNo: pointForBlue, servedBy: servedBy, concededBy: .Net, ballPlacedAt: .redNet, pointFor: .Blue))
            if currentServeBy == .B1 || currentServeBy == .B2{
                switchPlayerInBlue()
            }
            else{
                serviceCutToBlue()
            }
            break
        //** **//
            
        //** Points for Red**/
        case .innerBlue:
            pointStack.append(PBPoint(pointNo: pointForRed, servedBy: servedBy, concededBy: .place, ballPlacedAt: .innerRed, pointFor: .Red))
            if currentServeBy == .R1 || currentServeBy == .R2{
               switchPlayerInRed()
            }
            else{
                serviceCutToRed()
            }
            break
        case .outerRed:
            pointStack.append(PBPoint(pointNo: pointForRed, servedBy: servedBy, concededBy: .Away, ballPlacedAt: .outerRed, pointFor: .Red))
            if currentServeBy == .R1 || currentServeBy == .R2{
               switchPlayerInRed()
            }
            else{
                serviceCutToRed()
            }
            break
        case .blueNet:
            pointStack.append(PBPoint(pointNo: pointForRed, servedBy: servedBy, concededBy: .Net, ballPlacedAt: .blueNet, pointFor: .Red))
            if currentServeBy == .R1 || currentServeBy == .R2{
               switchPlayerInRed()
            }
            else{
                serviceCutToRed()
            }
            break
        //** **//
        }
        
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        pointForRed = 0
        pointForBlue = 0
        redGameLabel.text = "\(pointForRed)"
        blueGameLabel.text = "\(pointForBlue)"
        isGameOver = false
        
        playerBlueRightLabel.text = ServedBy.B1.playerName
        playerBlueLeftLabel.text = ServedBy.B2.playerName
        playerRedRightLabel.text = ServedBy.R1.playerName
        playerRedLeftLabel.text = ServedBy.R2.playerName
        
        redRightImage.image =  PlayerImageVariant.nonServeImage.image
        redLeftImage.image =  PlayerImageVariant.nonServeImage.image
        blueLeftImage.image =  PlayerImageVariant.nonServeImage.image
        blueRightImage.image =  PlayerImageVariant.serveImage.image
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

