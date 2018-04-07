//
//  Ball.swift
//  Breakout
//
//  Created by Fredrik on 03.04.18.
//  Copyright © 2018 fwcd. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 * The central object that can destroy bricks.
 */
class Ball: Circular, BallCollidable, Rendereable {
	private(set) var radius: CGFloat
	private(set) var pos: CGPoint
	private var collided: Bool = false
	var score = Holder<Int>(with: 0)
	let color: CGColor
	var velocity: CGVector
	
	init(x: CGFloat, y: CGFloat, radius: CGFloat, initialVelocity: CGFloat, color: CGColor) {
		pos = CGPoint(x: x, y: y)
		self.radius = radius
		self.color = color
		
		let angle: CGFloat = randomAngleRad(betweenDeg: 200, andDeg: 340)
		velocity = CGVector(angleRad: angle, length: initialVelocity)
	}
	
	func update(game: BreakoutGame) {
		collided = false
		
		if hitsXWall(game.bounds) {
			HorizontalWallCollision().perform(ball: self, collidable: nil)
			collided = true
		} else if hitsYWall(game.bounds) {
			VerticalWallCollision().perform(ball: self, collidable: nil)
			collided = true
		}
		
		if game.nextLevel != nil {
			performCollisions(with: game.nextLevel!.bricks,
			                  remover: {(i) -> () in game.nextLevel!.destroyBrick(at: i)})
		}
		performCollisions(with: [game.paddle], remover: nil)
		performCollisions(with: game.currentLevel.bricks,
		                  remover: {(i) -> () in game.currentLevel.destroyBrick(at: i)})
		performCollisions(with: game.balls, remover: nil)
		
		move()
	}
	
	func grow() {
		radius *= 2
	}
	
	func shrink() {
		radius /= 2
	}
	
	private func performCollisions(with collidables: [BallCollidable], remover: ((Int) -> ())!) {
		if !collided {
			var i: Int = 0
			for collidable in collidables {
				let collision = collidable.collisionWith(ball: self)
				if collision != nil {
					collision!.perform(ball: self, collidable: collidable)
					collidable.onHit(ball: self)
					if collidable.destroyUponHit() {
						score.value += 1
						remover(i)
					}
					collided = true
					break
				}
				i += 1
			}
		}
	}
	
	private func hitsXWall(_ bounds: CGRect) -> Bool {
		let x = pos.x + velocity.dx
		return (x - radius) < 0 || x >= bounds.width
	}
	
	private func hitsYWall(_ bounds: CGRect) -> Bool {
		let y = pos.y + velocity.dy
		return (y - radius) < 0 || y >= bounds.height
	}
	
	private func move() {
		pos.addMutate(velocity)
	}
	
	func render(to context: CGContext) {
		context.setFillColor(color)
		context.fillEllipse(in: CGRect(x: pos.x - radius, y: pos.y - radius, width: (radius * 2), height: (radius * 2)))
	}
	
	func collisionWith(ball: Ball) -> BallCollision? {
		if ball !== self {
			return collisionOf(movingCircle: self, withMovingCircle: ball)
		}
		
		return nil
	}
	
	func destroyUponHit() -> Bool {
		return false
	}
}
