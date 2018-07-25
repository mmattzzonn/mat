//
//  LoadingView.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 23..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    let frameColor = UIColor.white.withAlphaComponent(0.5)
    let frameWidth: CGFloat = 1.0
    let subFrames: Int = 3
    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
    let loadingFrameSize: CGFloat = UIScreen.main.bounds.width / 5.0
    var isFinish: Bool = false
    var subFrameList = [CALayer]()

    static let shared = LoadingView()

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func begin(target: UIView) {
        DispatchQueue.main.async {
            let view = LoadingView.shared
            view.alpha = 1.0
            target.addSubview(view)
            view.frame = target.bounds
            view.addSubFrames()
            view.backgroundColor = UIColor.black
            view.beginRotate()
            view.isFinish = false
        }
    }

    class func finish() {
        DispatchQueue.main.async {
            if LoadingView.shared.isFinish == false {
                LoadingView.shared.isFinish = true

                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                    LoadingView.shared.alpha = 0.0
                }, completion: { (completion) in
                    LoadingView.shared.reset()
                    LoadingView.shared.removeFromSuperview()
                })
            }
        }
    }

    class func failed() {
        LoadingView.shared.isFinish = true
        LoadingView.shared.reset()
    }

    private func reset() {
        self.layer.removeAllAnimations()
        self.subFrameList.removeAll()
        self.layer.sublayers?.removeAll()
    }

    private func addSubFrames() {
        for _ in 0...subFrames {
            let subLayer = CALayer.init(layer: self.layer)
            subLayer.frame = CGRect(x: (UIScreen.main.bounds.width - loadingFrameSize) / 2.0,
                                    y: (UIScreen.main.bounds.height -
                                        UIApplication.shared.statusBarFrame.height -
                                        44.0 - loadingFrameSize) / 2.0,
                                    width: loadingFrameSize,
                                    height: loadingFrameSize)
            
            subLayer.borderColor = frameColor.cgColor
            subLayer.borderWidth = frameWidth
            subFrameList.append(subLayer)
            self.layer.addSublayer(subLayer)
        }
    }

    @objc private func beginRotate() {
        for index in 0..<subFrameList.count {
            let subLayer = subFrameList[index]
            rotate360Degrees(target: subLayer, duration: 2.0, index: index)
        }
    }

    private func rotate360Degrees(target: CALayer, duration: CFTimeInterval = 1.0, index: Int) {
        let frameDuration: Double = duration / Double(subFrames + 1)
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = .infinity
        rotateAnimation.beginTime = CACurrentMediaTime() + (Double(index) * frameDuration) / 8.0
        rotateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.83, 0.07, 0.385, 0.8)
        target.add(rotateAnimation, forKey: nil)
    }

}
