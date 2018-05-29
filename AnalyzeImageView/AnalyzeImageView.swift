//
//  AnalyzeImageView.swift
//  AnalyzeImageView
//
//  Created by 寺家 篤史 on 2018/05/29.
//  Copyright © 2018年 Yumemi Inc. All rights reserved.
//

import UIKit
import SnapKit

class AnalyzeImageView: UIView {
    private let imageView = UIImageView()
    private let magnificationView = UIView()
    private let magnificationImageView = UIImageView()
    private let magnificationMaskLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = UIImage(named: "cancun_pool_bar.png")
        addSubview(imageView)

        magnificationView.isHidden = true
        magnificationView.clipsToBounds = true
        addSubview(magnificationView)

        magnificationImageView.image = imageView.image
        magnificationView.addSubview(magnificationImageView)
        
        magnificationMaskLayer.backgroundColor = UIColor.black.cgColor
        magnificationMaskLayer.cornerRadius = 100
        magnificationMaskLayer.frame.size = CGSize(width: 200, height: 200)
        magnificationImageView.layer.mask = magnificationMaskLayer

        imageView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }

        magnificationView.snp.makeConstraints { (make) in
            make.center.size.equalTo(imageView)
        }

        magnificationImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(2.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startEffect() {
        guard imageView.image != nil else { return }
        
        var animations: [CABasicAnimation] = []
        let magnificationImageRect = magnificationImageView.frame
        
        // Returns random point
        func randomPosition() -> CGPoint {
            let size = CGSize(width: magnificationImageRect.width, height: magnificationImageRect.height)
            let xPoints: [CGFloat] = [size.width * 0.2, size.width * 0.35, size.width * 0.45, size.width * 0.55, size.width * 0.65, size.width * 0.8]
            let yPoints: [CGFloat] = [size.height * 0.2, size.height * 0.35, size.height * 0.45, size.height * 0.55, size.height * 0.65, size.height * 0.8]
            let x = xPoints[Int(arc4random() % UInt32(xPoints.count))]
            let y = yPoints[Int(arc4random() % UInt32(yPoints.count))]
            return CGPoint(x: x, y: y)
        }
        
        func appendAnimation(position: CGPoint, nextPosition: CGPoint, totalDuration: CFTimeInterval) -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = position
            animation.toValue = nextPosition
            animation.duration = 1.0 + CFTimeInterval(arc4random() % UInt32(2))
            animation.beginTime = totalDuration
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            animations.append(animation)
            return animation
        }
        
        magnificationView.isHidden = false
        magnificationImageView.image = imageView.image
        
        // Start from center
        var position: CGPoint = CGPoint(x: magnificationImageRect.width / 2, y: magnificationImageRect.height / 2)
        let initialPosition: CGPoint = position
        var totalDuration = 0.0
        for _ in 0...10 {
            var nextPosition: CGPoint
            repeat {
                nextPosition = randomPosition()
            } while nextPosition == position
            let animation = appendAnimation(position: position, nextPosition: nextPosition, totalDuration: totalDuration)
            position = nextPosition
            totalDuration += animation.duration
        }
        // Back to initial position for loop
        let lastAnimation = appendAnimation(position: position, nextPosition: initialPosition, totalDuration: totalDuration)
        totalDuration += lastAnimation.duration
        
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = totalDuration
        group.repeatCount = Float.infinity
        magnificationMaskLayer.add(group, forKey: "positionAnimation")
    }

    func stopEffect() {
        magnificationMaskLayer.removeAllAnimations()
        magnificationImageView.image = nil
        magnificationView.isHidden = true
    }
}
