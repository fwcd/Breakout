//
//  ItemBrick.swift
//  Breakout
//
//  Created by Fredrik on 07.04.18.
//  Copyright © 2018 fwcd. All rights reserved.
//

import Foundation
import UIKit

/**
 * A brick that spawns an item upon being hit.
 */
class ItemBrick: BasicBrick {
	override func getColor() -> CGColor {
		return UIColor.cyan.cgColor
	}
	
	override func onHit(ball: Ball) {
		let item = game.currentLevel.sampleItem()
		item.place(at: pos, withSpeed: 2, andRadius: game.bounds.width * 0.15)
		game.items.append(item)
	}
	
	override func destroyUponHit() -> Bool {
		return true
	}
	
	override func affectsLevelCounter() -> Bool {
		return true
	}
}
