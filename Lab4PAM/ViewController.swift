import UIKit
import Gifu

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBarView: UIView!
    
    @IBOutlet weak var loadingGif: GIFImageView!
    
    private var gfst = GIFStates.stopped
    var gifState: GIFStates {
        
        get {
            return self.gfst
        } set (newValue) {
            gfst = newValue
            switch gfst {
            case .stopped:
                loadingGif.stopAnimatingGIF()
                timer.invalidate()
                seconds = Float(maxSeconds)
                
            case .playing:
                loadingGif.stopAnimatingGIF()
                timer.invalidate()
                seconds = Float(maxSeconds)
                loadingGif.startAnimatingGIF()
                runTimer()
            }
        }
    }
    @IBOutlet weak var ProgressLabel: UILabel!
    
    var timer = Timer()
    var maxSeconds = 8
    var seconds: Float = 8
    var interval: Float = 0.618
    
    func runTimer() {
        resetStrokeEnd()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.interval), target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= interval
        
        var prc = Int((Float(maxSeconds) - seconds)/Float(maxSeconds)*100)
        prc = prc > 100 ? 100 : prc
        if prc == 100 {
            gifState = .stopped
        }
        ProgressLabel.text = "\(prc)%"
        
        updateEndStroke(value: Float(prc)/Float(100))
    }

    let shapeLayer = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadingGif.contentMode = .scaleAspectFit
        loadingGif.animate(withGIFNamed: "giphy")
        gifState = .playing
        
        loadLoadingIndicator()
    }
    
    func loadLoadingIndicator() {
        let center = CGPoint(x: progressBarView.frame.width/2, y: progressBarView.frame.height/2)
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 55, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi*1.5, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 13
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        progressBarView.layer.addSublayer(trackLayer)
        
        self.shapeLayer.path = circularPath.cgPath
        self.shapeLayer.strokeColor = UIColor.red.cgColor
        self.shapeLayer.lineWidth = 10
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.shapeLayer.lineCap = .round
        self.shapeLayer.strokeEnd = 0
        progressBarView.layer.addSublayer(shapeLayer)
    }
    
    func resetStrokeEnd() {
        self.shapeLayer.strokeEnd = 0
    }
    
    func updateEndStroke(value: Float) {
        self.shapeLayer.strokeEnd = CGFloat(value)
    }

    @IBAction func ButtonsTapped(_ sender: UIButton) {
        gifState = sender.titleLabel?.text == "Start" ? .playing : .stopped
    }
    
}

enum GIFStates {
    case stopped
    case playing
}

