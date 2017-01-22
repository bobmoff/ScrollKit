//
// ScrollKit
// https://github.com/bobmoff/ScrollKit
// Created by Fille Åström
//

import Foundation
import SpriteKit

enum IIMySceneZPosition: Int {
	case Scrolling = 0
	case VerticalAndHorizontalScrolling
	case Static
}

public class IIMyScene: SKScene {

	var innerContentSize: CGSize = CGSize.zero
	public var contentSize: CGSize {
		get {
			return innerContentSize
		}
		set {
			if !newValue.equalTo(innerContentSize) {
				innerContentSize = newValue
				self.spriteToScroll?.size = newValue
				self.spriteForScrollingGeometry?.size = newValue
				self.spriteForScrollingGeometry?.position = CGPoint.zero
				updateConstrainedScrollerSize()
			}
		}
	}
	
	var innerContentOffset: CGPoint = CGPoint.zero
	public var contentOffset: CGPoint {
		get {
			return innerContentOffset
		}
		set {
			if !newValue.equalTo(innerContentOffset) {
				innerContentOffset = newValue
				contentOffsetReload()
			}
		}
	}
	
	func contentOffsetReload() {
        self.spriteToScroll?.position = CGPoint(x: -innerContentOffset.x, y: -innerContentOffset.y)
		
		if let spriteForScrollingGeometry = self.spriteForScrollingGeometry,
			let spriteToHostHorizontalAndVerticalScrolling = self.spriteToHostHorizontalAndVerticalScrolling,
			let spriteForHorizontalScrolling = self.spriteForHorizontalScrolling,
			let spriteForVerticalScrolling = self.spriteForVerticalScrolling {
				let scrollingLowerLeft = spriteForScrollingGeometry.convert(CGPoint.zero, to: spriteToHostHorizontalAndVerticalScrolling)
				
				var horizontalScrollingPosition = spriteForHorizontalScrolling.position
				horizontalScrollingPosition.y = scrollingLowerLeft.y
				spriteForHorizontalScrolling.position = horizontalScrollingPosition
				
				var verticalScrollingPosition = spriteForVerticalScrolling.position
				verticalScrollingPosition.x = scrollingLowerLeft.x
				spriteForVerticalScrolling.position = verticalScrollingPosition
		}
	}
	
	//kIIMySceneZPositionScrolling
	weak var spriteToScroll: SKSpriteNode?
	weak var spriteForScrollingGeometry: SKSpriteNode?
	
	//kIIMySceneZPositionStatic
	weak var spriteForStaticGeometry: SKSpriteNode?
	
	// ZPosition VerticalAndHorizontalScrolling
	weak var spriteToHostHorizontalAndVerticalScrolling: SKSpriteNode?
	weak var spriteForHorizontalScrolling: SKSpriteNode?
	weak var spriteForVerticalScrolling: SKSpriteNode?

	
	override init(size: CGSize) {
		super.init(size: size)
		self.anchorPoint = CGPoint.zero

		let spriteToScroll = SKSpriteNode(color: SKColor.clear, size: size)
		spriteToScroll.anchorPoint = CGPoint.zero
		spriteToScroll.zPosition = CGFloat(IIMySceneZPosition.Scrolling.rawValue)
		self.addChild(spriteToScroll)
		
		//Overlay sprite to make anchor point 0,0 (lower left, default for SK)
		let spriteForScrollingGeometry = SKSpriteNode(color: SKColor.clear, size: size)
		spriteForScrollingGeometry.anchorPoint = CGPoint.zero
		spriteForScrollingGeometry.position = CGPoint.zero
		spriteForScrollingGeometry.zPosition = CGFloat(IIMySceneZPosition.Scrolling.rawValue)
		spriteToScroll.addChild(spriteForScrollingGeometry)
		
		let spriteForStaticGeometry = SKSpriteNode(color: SKColor.clear, size: size)
		spriteForStaticGeometry.anchorPoint = CGPoint.zero
		spriteForStaticGeometry.position = CGPoint.zero
		spriteForStaticGeometry.zPosition = CGFloat(IIMySceneZPosition.Static.rawValue)
		self.addChild(spriteForStaticGeometry)
		
		let spriteToHostHorizontalAndVerticalScrolling = SKSpriteNode(color: SKColor.clear, size: size)
		spriteToHostHorizontalAndVerticalScrolling.anchorPoint = CGPoint.zero
		spriteToHostHorizontalAndVerticalScrolling.position = CGPoint.zero
		spriteToHostHorizontalAndVerticalScrolling.zPosition = CGFloat(IIMySceneZPosition.VerticalAndHorizontalScrolling.rawValue)
		self.addChild(spriteToHostHorizontalAndVerticalScrolling)

		var upAndDownSize = size
		upAndDownSize.width = 30
		let spriteForVerticalScrolling = SKSpriteNode(color: SKColor.clear, size: upAndDownSize)
		spriteForVerticalScrolling.anchorPoint = CGPoint.zero
        spriteForVerticalScrolling.position = CGPoint(x: 0, y: 30)
		spriteToHostHorizontalAndVerticalScrolling.addChild(spriteForVerticalScrolling)

		var leftToRightSize = size
		leftToRightSize.height = 30
		let spriteForHorizontalScrolling = SKSpriteNode(color: SKColor.clear, size: leftToRightSize)
		spriteForHorizontalScrolling.anchorPoint = CGPoint.zero
        spriteForHorizontalScrolling.position = CGPoint(x: 10, y: 0)
		spriteToHostHorizontalAndVerticalScrolling.addChild(spriteForHorizontalScrolling)
		
		//Test sprites for constrained Scrolling
		var labelPosition = CGFloat(-500.0)
		let stepSize = CGFloat(50.0)
		while labelPosition < 2000.0 {
			let labelText = String(format: "%5.0f", labelPosition)

			let hscrollingLabel = SKLabelNode(fontNamed: "HelveticaNeue")
			hscrollingLabel.text = labelText
			hscrollingLabel.fontSize = 14
			hscrollingLabel.fontColor = SKColor.darkGray
            hscrollingLabel.position = CGPoint(x: 0, y: labelPosition)
			hscrollingLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
			spriteForHorizontalScrolling.addChild(hscrollingLabel)

			let scrollingLabel = SKLabelNode(fontNamed: "HelveticaNeue")
			scrollingLabel.text = labelText
			scrollingLabel.fontSize = 14
			scrollingLabel.fontColor = SKColor.darkGray
            scrollingLabel.position = CGPoint(x: labelPosition, y: 0)
			scrollingLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
			spriteForVerticalScrolling.addChild(scrollingLabel)
			
			labelPosition += stepSize
		}

		//Test sprites for scrolling and zooming
        let greenTestSprite = SKSpriteNode(color: SKColor.green, size: CGSize(width: size.width, height: size.height * 0.25))
		greenTestSprite.name = "greenTestSprite"
		greenTestSprite.anchorPoint = CGPoint.zero
		spriteForScrollingGeometry.addChild(greenTestSprite)
		
        let blueTestSprite = SKSpriteNode(color: SKColor.blue, size: CGSize(width: size.width * 0.25, height: size.height * 0.25))
		blueTestSprite.name = "blueTestSprite"
		blueTestSprite.anchorPoint = CGPoint.zero
        blueTestSprite.position = CGPoint(x: size.width * 0.25, y: size.height * 0.65)
		spriteForScrollingGeometry.addChild(blueTestSprite)
		
		//Test sprites for stationary sprites
		let stationaryLabel = SKLabelNode(fontNamed: "HelveticaNeue")
		stationaryLabel.text = "I'm not gonna move, nope, nope."
		stationaryLabel.fontSize = 14
		stationaryLabel.fontColor = SKColor.darkGray
        stationaryLabel.position = CGPoint(x: 60, y: 80)
		stationaryLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
		spriteForStaticGeometry.addChild(stationaryLabel)
		
		
		//Set properties
		self.contentSize = size
		self.spriteToScroll = spriteToScroll
		self.spriteForScrollingGeometry = spriteForScrollingGeometry
		self.spriteForStaticGeometry = spriteForStaticGeometry
		self.spriteToHostHorizontalAndVerticalScrolling = spriteToHostHorizontalAndVerticalScrolling
		self.spriteForVerticalScrolling = spriteForVerticalScrolling
		self.spriteForHorizontalScrolling = spriteForHorizontalScrolling
		self.contentOffset = CGPoint.zero
	}

	required public init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override public func didChangeSize(_ oldSize: CGSize) {
		let size = self.size
		
		
		self.spriteForStaticGeometry?.size = size
		self.spriteForStaticGeometry?.position = CGPoint.zero
		
		self.spriteToHostHorizontalAndVerticalScrolling?.size = size
		self.spriteToHostHorizontalAndVerticalScrolling?.position = CGPoint.zero
	}
	
	func setContentScale(scale: CGFloat) {
		spriteToScroll?.setScale(scale)
		updateConstrainedScrollerSize()
	}
	
	func updateConstrainedScrollerSize() {
		let contentSize: CGSize = self.contentSize
		
		var verticalSpriteSize: CGSize = self.spriteForVerticalScrolling?.size ?? CGSize.zero
		verticalSpriteSize.height = contentSize.height
		spriteForVerticalScrolling?.size = verticalSpriteSize
		
		var horizontalSpriteSize = self.spriteForHorizontalScrolling?.size ?? CGSize.zero
		horizontalSpriteSize.width = contentSize.width
		spriteForHorizontalScrolling?.size = horizontalSpriteSize
		
		let xScale = spriteToScroll?.xScale ?? 1.0
		let yScale = spriteToScroll?.yScale ?? 1.0
		
		spriteForVerticalScrolling?.xScale = xScale
		spriteForVerticalScrolling?.yScale = yScale
		
		spriteForHorizontalScrolling?.xScale = xScale
		spriteForHorizontalScrolling?.yScale = yScale
		
		let xScaleReciprocal = 1.0 / xScale
		let yScaleReciprocal = 1.0 / yScale
		for node in spriteForVerticalScrolling?.children ?? [] {
			node.xScale = xScaleReciprocal
			node.yScale = yScaleReciprocal
		}

		for node in spriteForHorizontalScrolling?.children ?? [] {
			node.xScale = xScaleReciprocal
			node.yScale = yScaleReciprocal
		}

		contentOffsetReload()
	}
}
