//
//  ViewController.swift
//  DragAlongbezierPath
//
//  Created by SA on 7/8/17.
//  Copyright © 2017 Sris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emojiView: UIView!
    
    var p0 : CGPoint!
    var p1 : CGPoint!
    var p2 : CGPoint!
    var emojiCenter: CGPoint!
    
    var bezierPath = UIBezierPath()
    var bezierPathYMax: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBezierPath()
        let dragPan = UIPanGestureRecognizer(target: self, action: #selector(dragEmotionOnBezier(recognizer:)))
        view.addGestureRecognizer(dragPan)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //set the emojiView center at randon point on Bezier path. Setting the starting point here
        emojiView.center = p0
        //store the initial position of emoji
        emojiCenter = p0
    }

 
    /*
     Draw Bezier Quad curve and get the path.
     */
    func drawBezierPath() {
        
        let maxLeftPoint = emojiView.center
        p0 = CGPoint(x: view.center.x + 30, y: view.center.y - 200)
        
        p2  = CGPoint(x: view.center.x + 30, y: view.center.y + 200)
        
        p1 = CGPoint(x: halfPoint1D(p0: p0.x, p2: p2.x, control: maxLeftPoint.x),
                          y: halfPoint1D(p0: p0.y, p2: p2.y, control: maxLeftPoint.y))
        
        
        bezierPath.move(to: p0)
        bezierPath.addQuadCurve(to: p2, controlPoint: p1)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 3.0
        view.layer.addSublayer(shapeLayer)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        
        //Store the max Y distance covered by UIbezierPath. It will be useful to calculate the intermidiate point on curve 
        // at the distance y from the start point po
        bezierPathYMax = p2.y - p0.y
        
    }
    
    
    func halfPoint1D(p0: CGFloat, p2: CGFloat, control: CGFloat) -> CGFloat {
        return 2 * control - p0 / 2 - p2 / 2
    }
    
    
    /* Refered from http://ericasadun.com/2013/03/25/calculating-bezier-points/
     - params: start point, end point, control point and the time drawn factor between 0 to 1.
    */
    func getPointAtPercent(t: Float, start: Float, c1: Float, end: Float ) -> Float {
        let t_: Float = (1.0 - t)
        let tt_: Float = t_ * t_
        let tt: Float = t * t
        
        return start * tt_
            + 2.0 * c1 * t_ * t
            + end * tt
    }
    
    
    func dragEmotionOnBezier(recognizer: UIPanGestureRecognizer) {
        
        let point = recognizer.location(in: view)
        let distanceY = point.y - emojiCenter.y
        // get the value between 0 & 1. 0 represents and po and 1 represent p2.
        var distanceYInRange = distanceY / bezierPathYMax
        distanceYInRange = distanceYInRange > 0 ? distanceYInRange : -distanceYInRange
        
        if distanceYInRange >= 1 || distanceYInRange <= 0 {
            // already at the end of the curve. So need to drag
            return
        }
        
        // get the x,y point on the Bezier path at a distance distanceYInRange from p.
        let newY = getPointAtPercent(t: Float(distanceYInRange), start: Float(p0.y) , c1: Float(p1.y), end: Float(p2.y))
        
        let newX = getPointAtPercent(t: Float(distanceYInRange), start: Float(p0.x) , c1: Float(p1.x), end: Float(p2.x))
        
        // set the newLocation of the emojiview
        emojiView.center = CGPoint(x: CGFloat(newX), y: CGFloat(newY))
        
        
    }
    
    

}

