
//  Created by Hemanth Kotla(301084656), Pratiksha Kathiriya (301093309), Kevin Nobel (301093673) on 2020-01-17.
// last modified on 2020-01-21
// File Description : Main view controller
// Revision history :
// v1 : Design
// v2: adding pickerview and images
// v3 : logic behind the reels
// v4 : Adding sounds and animations


import UIKit
import AVFoundation
import Foundation
import Darwin

class ViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate{
    
    let images = [#imageLiteral(resourceName: "man"),#imageLiteral(resourceName: "captianam"),#imageLiteral(resourceName: "thoro1"),#imageLiteral(resourceName: "hulkogan"),#imageLiteral(resourceName: "blackwidow"),#imageLiteral(resourceName: "Bar-1"),#imageLiteral(resourceName: "7"),#imageLiteral(resourceName: "blank")]
    
    @IBOutlet weak var machineImageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet weak var userIndicatorlabel: UILabel!
    @IBOutlet weak var cashImageView: UIImageView!
    @IBOutlet weak var cashToRiskLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var playerMoney = 1000;
    var winnings = 0;
    var jackpot = 5000;
    var turn = 0;
    var playerBet = 0;
    var winNumber = 0;
    var lossNumber = 0;
    var avengers = "";
    var winRatio = 0;
    var ironman = 0;
    var captian = 0;
    var thor = 0;
    var hulk = 0;
    var bars = 0;
    var blackwidow = 0;
    var sevens = 0;
    var blanks = 0;

    
    @IBAction func stepperAction(_ sender: UIStepper) {
        stepper.maximumValue = Double(currentCash)
        let amount = Int(sender.value)
        if currentCash >= amount{
            cashToRisk = amount
            cashToRiskLabel.text = "\(amount)$"
        }
    }
    
    @IBOutlet weak var cashLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        
        // swipeDown GestureRecognizer
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    // Bet amount
    var cashToRisk : Int = 10{
        didSet{//update ui
            cashToRiskLabel.text = "\(currentCash)$"
        }
    }
    
    var currentCash : Int{
        guard let cash = cashLabel.text, !(cashLabel.text?.isEmpty)! else {
            return 0
        }
        return Int(cash.replacingOccurrences(of: "$", with: ""))!
    }
    
    func startGame(){
        if Model.instance.isFirstTime(){ // check if it's first time playing
            Model.instance.updateScore(label: cashLabel, cash: 1000)
        }else{ // get last saved score
            Model.instance.updateScore(label: cashLabel, cash: 1000)
        } // set max bet
        stepper.maximumValue = Double(currentCash)
    }
    
    func roll(){ // roll pickerview
        var delay : TimeInterval = 0
        // iterate over each component, set random img
        for i in 0..<pickerView.numberOfComponents{
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.randomSelectRow(in: i)
            })
            delay += 0.30
        }
    }

    func checkRange( _ value: Int , _ lowerBound: Int, _ upperBound:Int) -> Int {
        if (value >= lowerBound && value <= upperBound)
        {
            return value
        }
        else {
            return 0
        }
    }
    
    
      //probability for the spin
    func randomSelectRow(in comp : Int) {
        
        
        func reel() -> [String]
        {
            
            var betLine = [" ", " ", " "]
            var outCome = [0, 0, 0]
            
            let randomInt = Double.random(in: 0..<1)
            
  
            
            for i in 0..<pickerView.numberOfComponents{
                
      
                for spin in 0...3  {
                    outCome[spin] = Int((randomInt * 65) + 1);
                    switch (outCome[spin]) {
                    case checkRange(outCome[spin], 1, 27):  // 41.5% probability
                        betLine[spin] = "blanks";
                        blanks += 1;
                        break;
                    case checkRange(outCome[spin], 28, 37): // 15.4% probability
                        betLine[spin] = "captian";
                        captian += 1;
                        break;
                    case checkRange(outCome[spin], 38, 46): // 13.8% probability
                        betLine[spin] = "thor";
                        thor += 1;
                        break;
                    case checkRange(outCome[spin], 47, 54): // 12.3% probability
                        betLine[spin] = "hulk";
                        hulk += 1;
                        break;
                    case checkRange(outCome[spin], 55, 59): //  7.7% probability
                        betLine[spin] = "ironman";
                        ironman += 1;
                        break;
                    case checkRange(outCome[spin], 60, 62): //  4.6% probability
                        betLine[spin] = "Bars";
                        bars += 1;
                        break;
                    case checkRange(outCome[spin], 63, 64): //  3.1% probability
                        betLine[spin] = "blackwidow";
                        blackwidow += 1;
                        break;
                    case checkRange(outCome[spin], 65, 65): //  1.5% probability
                        betLine[spin] = "Seven";
                        sevens += 1;
                        break;
                    default:
                        print(spin)
                    }
                }
                
            }
            return betLine;
        }
        
        let r = Int(arc4random_uniform(UInt32(8 * images.count))) + images.count
        pickerView.selectRow(r, inComponent: comp, animated: true)
        
    }
    
    
    
    func checkWin(){
        
        var lastRow = -1
        var counter = 0
        
        for i in 0..<pickerView.numberOfComponents{
            let row : Int = pickerView.selectedRow(inComponent: i) % images.count // selected img idx
            print (row)
            if lastRow == row{ // two equals indexes
                counter += 1
            } else {
                lastRow = row
                counter = 1
                
            }
        }
        
        // Getting the index values of the images and assigning them to variable
        
        
        let row1 : Int = pickerView.selectedRow(inComponent: 0) % images.count
        let row2 : Int = pickerView.selectedRow(inComponent: 1) % images.count
        let row3 : Int = pickerView.selectedRow(inComponent: 2) % images.count
        
        // checking for Jackpot
        
        if row1 == row2 && row1 == row3
        {
            Model.instance.play(sound: Constant.tada_sound)
            animate(view: machineImageView, images: [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo")], duration: 1, repeatCount: 15)
            stepper.maximumValue = Double(currentCash)
            
            userIndicatorlabel.text = "YOU WON \(200 + cashToRisk * 2)$"
            Model.instance.updateScore(label: cashLabel,cash: (currentCash + 200) + (cashToRisk * 2))
            
            
            
            if row1 == 0
            {
                Model.instance.play(sound: Constant.tada_sound)
                animate(view: machineImageView, images: [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo")], duration: 1, repeatCount: 15)
                stepper.maximumValue = Double(currentCash)
                
                stepper.maximumValue = Double(currentCash)
                
                userIndicatorlabel.text = "You Won \(cashToRisk * 10)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 10))
            }
            else if row1 == 1
            {
                Model.instance.play(sound: Constant.tada_sound)
                animate(view: machineImageView, images: [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo")], duration: 1, repeatCount: 15)
                stepper.maximumValue = Double(currentCash)
                userIndicatorlabel.text = "You Won \(cashToRisk * 20)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 20))
            }
            else if row1 == 2
            {
                Model.instance.play(sound: Constant.tada_sound)
                animate(view: machineImageView, images: [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo")], duration: 1, repeatCount: 15)
                animate(view: cashImageView, images: [#imageLiteral(resourceName: "change"),#imageLiteral(resourceName: "extra_change")], duration: 1, repeatCount: 15)
                stepper.maximumValue = Double(currentCash)
                userIndicatorlabel.text = "You Won \(cashToRisk * 30)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 30))
            }
            else if row1 == 3
            {
                Model.instance.play(sound: Constant.tada_sound)
                animate(view: machineImageView, images: [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo")], duration: 1, repeatCount: 15)
                stepper.maximumValue = Double(currentCash)
                userIndicatorlabel.text = "You Won \(cashToRisk * 40)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 40))
            }
            else if row1 == 4
            {
                Model.instance.play(sound: Constant.tada_sound)
                animate(view: machineImageView, images: [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo")], duration: 1, repeatCount: 15)
                animate(view: cashImageView, images: [#imageLiteral(resourceName: "change"),#imageLiteral(resourceName: "extra_change")], duration: 1, repeatCount: 15)
                stepper.maximumValue = Double(currentCash)
                userIndicatorlabel.text = "You Won \(cashToRisk * 50)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 50))
            }
            else if row1 == 5
            {
                Model.instance.play(sound: Constant.tada_sound)
                animate(view: machineImageView, images: [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo")], duration: 1, repeatCount: 15)
                animate(view: cashImageView, images: [#imageLiteral(resourceName: "change"),#imageLiteral(resourceName: "extra_change")], duration: 1, repeatCount: 15)
                stepper.maximumValue = Double(currentCash)
                userIndicatorlabel.text = "You Won \(cashToRisk * 75)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 75))
            }
            else if row1 == 6
            {
                
                Model.instance.play(sound: Constant.tada_sound)
                animate(view: machineImageView, images: [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo")], duration: 1, repeatCount: 15)
                animate(view: cashImageView, images: [#imageLiteral(resourceName: "change"),#imageLiteral(resourceName: "extra_change")], duration: 1, repeatCount: 15)
                stepper.maximumValue = Double(currentCash)
                userIndicatorlabel.text = "You Won \(cashToRisk * 100)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 100))
            }
            else if row1 == 7
            {
                userIndicatorlabel.text = "TRY AGAIN"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash - cashToRisk))
            }
            
            
            
            
            
            
        }
            
            
       // checking for two equal images
            
        else if row1 == row2
        {
            if row1 == 0
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 2)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 2))
            }
            else if row1 == 1
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 2)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 2))
            }
            else if row1 == 2
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 3)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 3))
            }
            else if row1 == 3
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 4)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 4))
            }
            else if row1 == 4
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 5)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 5))
            }
            else if row1 == 5
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 10)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 10))
            }
            else if row1 == 6
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 20)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 20))
            }
            else
            {
                userIndicatorlabel.text = "TRY AGAIN"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash - cashToRisk))
            }
            
        }
            
       // checking for two equal images
            
            
        else if row2 == row3
        {
            
            
            if row2 == 0
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 2)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 2))
            }
            else if row2 == 1
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 2)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 2))
            }
            else if row2 == 2
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 3)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 3))
            }
            else if row2 == 3
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 4)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 4))
            }
            else if row2 == 4
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 5)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 5))
            }
            else if row2 == 5
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 10)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 10))
            }
            else if row2 == 6
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 20)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 20))
            }
            else
            {
                
                userIndicatorlabel.text = "TRY AGAIN"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash - cashToRisk))
            }
        }
            
            
            
            // checking for two equal images
        else if row3 == row1
        {
            if row1 == 0
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 2)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 2))
            }
            else if row1 == 1
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 2)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 2))
            }
            else if row1 == 2
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 3)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 3))
            }
            else if row1 == 3
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 4)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 4))
            }
            else if row1 == 4
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 5)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 5))
            }
            else if row1 == 5
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 10)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 10))
            }
            else if row1 == 6
            {
                Model.instance.play(sound: Constant.you_winn)
                userIndicatorlabel.text = "You Won \(cashToRisk * 20)"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash) + (cashToRisk * 20))
            }
            else
            {
                userIndicatorlabel.text = "TRY AGAIN"
                Model.instance.updateScore(label: cashLabel,cash: (currentCash - cashToRisk))
            }
        }
            
        else
        {
            userIndicatorlabel.text = "TRY AGAIN"
            Model.instance.updateScore(label: cashLabel,cash: (currentCash - cashToRisk))
        }
        
 
        //checking if current is lower
        
        if currentCash <= 0 {
            gameOver()
        }else{  // update bet stepper
            if Int(stepper.value) > currentCash {
                stepper.maximumValue = Double(currentCash)
                cashToRisk = currentCash
                stepper.value = Double(currentCash)
            }
        }
    }
    
    
    // when game is over, show alert
    
    func gameOver(){
        let alert = UIAlertController(title: "Game Over", message: "You have \(currentCash)$ \nPlay Again?", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.startGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // when spining
    @IBAction func spinBarAction(_ sender: UITapGestureRecognizer) {
        spinAction()
    }
    
    
    // animation for the bar handle
    func spinAction(){
        barImageView.isUserInteractionEnabled = false // disable clicking
        // animation of bandit handle
        animate(view: barImageView, images: #imageLiteral(resourceName: "mot").spriteSheet(cols: 14, rows: 1), duration: 0.5, repeatCount: 1)
        userIndicatorlabel.text = ""
        Model.instance.play(sound: Constant.thanos_snap)
        roll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkWin()
            self.barImageView.isUserInteractionEnabled = true
        }
        
    }
    
    
    // picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count * 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let index = row % images.count
        return UIImageView(image: images[index])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return images[component].size.height + 2
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down: self.spinAction()
            default:break
            }
        }
    }
    
}


