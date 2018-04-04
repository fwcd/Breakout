//
//  BreakoutGameController.swift
//  Breakout
//
//  Created by Fredrik on 03.04.18.
//  Copyright © 2018 fwcd. All rights reserved.
//

import UIKit

class BreakoutGameController : UIViewController {
	let preferredFPS = 30
	var displayLink: CADisplayLink!
	var bView: BreakoutGame {
		get { return view as! BreakoutGame }
	}
	override var prefersStatusBarHidden: Bool {
		get { return true }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		bView.prepare(initialBallSpeed: 9, initialBallCount: 20)
		
		// Initialize gameloop
		
		displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
		if #available(iOS 10.0, *) {
			displayLink.preferredFramesPerSecond = preferredFPS
		}
		displayLink.add(to: .main, forMode: .commonModes)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch: UITouch! = touches.first
		bView.paddle.moveTo(x: touch.location(in: bView).x)
	}
	
	@objc
	private func gameLoop() {
		bView.update()
		
		for ball in bView.balls {
			ball.update(game: bView)
		}
		
		bView.setNeedsDisplay()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
