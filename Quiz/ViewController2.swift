//
//  ViewController2.swift
//  Quiz
//
//  Created by Carl Lundstedt on 02/03/16.
//  Copyright © 2016 Carl Lundstedt. All rights reserved.
//

import UIKit

class QuizController: UIViewController {

    @IBOutlet weak var timeLeftBar: UIProgressView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var altOne: UIButton!
    @IBOutlet weak var altTwo: UIButton!
    @IBOutlet weak var altThree: UIButton!
    @IBOutlet weak var altFour: UIButton!
    
    
    var timer = NSTimer()
    var timeLeft: Float = 10
    var progress: Float = 1.0
    var currentQuestion: Int = 0
    var buttons: [UIButton] = []
    var quiz: Quiz?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(quiz!.questions.count)
        buttons = [altOne, altTwo, altThree, altFour]
        updateQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        if(timer.valid) {
            let index = buttons.indexOf(sender)
            timer.invalidate()
            if(quiz!.questions[currentQuestion].answers[index!].correct) {
                sender.backgroundColor = UIColor.greenColor()
                quiz!.points += Int(timeLeftBar.progress*10)
            } else {
                sender.backgroundColor = UIColor.redColor()
            }
            currentQuestion++
            pointsLabel.text = "\(quiz!.points)"
            
            if(currentQuestion <= (quiz!.questions.count-1)){
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.updateQuestion()
                }
            }
        }
    }
    
    
    func countDown() {
        
        timeLeft -= 0.1
        progress = timeLeft/10.0
        update()
        
        if(timeLeft <= 0) {
           gotoMain()
        }
    }
    
    func update() {
        timeLeftBar.setProgress(progress, animated: true)
        if(timeLeft%1 < 0.1){
            timeLeftLabel.text = "\(Int(timeLeft))"
        }
    }
    
    func updateQuestion(){
        
        questionLabel.text = quiz!.questions[currentQuestion].question
        for button in buttons {
            button.setTitle(quiz!.questions[currentQuestion].answers[buttons.indexOf(button)!].answer, forState: .Normal)
            button.backgroundColor = UIColor.whiteColor()
        }
        startTimer()
    }
    
    func startTimer() {
        timeLeft = 10
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "countDown", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func gotoMain() {
        timer.invalidate()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("MainMenu")
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
}
