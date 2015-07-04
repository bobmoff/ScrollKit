//
// ScrollKit
// https://github.com/bobmoff/ScrollKit
// Created by Fille Åström
//

import SpriteKit

enum IIMySceneZPosition: Int {
	case Scrolling = 0
	case VerticalAndHorizontalScrolling
	case Static
}

public class IIMyScene: SKScene {

	var innerContentSize: CGSize = CGSizeZero
	public var contentSize: CGSize {
		get {
			return innerContentSize
		}
		set {
			if (!CGSizeEqualToSize(newValue, innerContentSize)) {
				innerContentSize = newValue
				self.spriteToScroll?.size = newValue
				self.spriteForScrollingGeometry?.size = newValue
				self.spriteForScrollingGeometry?.position = CGPointMake(0, -newValue.height)
				updateConstrainedScrollerSize()
			}
		}
	}
	
	var innerContentOffset: CGPoint = CGPointZero
	public var contentOffset: CGPoint {
		get {
			return innerContentOffset
		}
		set {
			innerContentOffset = newValue
			contentOffsetReload()
		}
	}
	
	func contentOffsetReload() {
		self.spriteToScroll?.position = CGPointMake(-innerContentOffset.x, innerContentOffset.y)
		
		if let spriteForScrollingGeometry = self.spriteForScrollingGeometry,
			spriteToHostHorizontalAndVerticalScrolling = self.spriteToHostHorizontalAndVerticalScrolling,
			spriteForHorizontalScrolling = self.spriteForHorizontalScrolling,
			spriteForVerticalScrolling = self.spriteForVerticalScrolling {
				let scrollingLowerLeft = spriteForScrollingGeometry.convertPoint(CGPointZero, toNode: spriteToHostHorizontalAndVerticalScrolling)
				
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
	
	//kIIMySceneZPositionVerticalAndHorizontalScrolling
	weak var spriteToHostHorizontalAndVerticalScrolling: SKSpriteNode?
	weak var spriteForHorizontalScrolling: SKSpriteNode?
	weak var spriteForVerticalScrolling: SKSpriteNode?

	
	override init(size: CGSize) {
		super.init(size: size)

		//Anchor point is {0,1} <-- Don't change that or scrolling will get messed-up
		//If you want to use some other anchor point, add a subnode with a more appropriate
		//anchor point and offset it appropriately; see the spriteForScrollingGeometry and
		//spriteForStaticGeometry private properties in initWithSize: for how to do this.
		self.anchorPoint = CGPointMake(0, 1)

		let spriteToScroll = SKSpriteNode(color: SKColor.clearColor(), size: size)
		spriteToScroll.anchorPoint = CGPointMake(0, 1)
		spriteToScroll.zPosition = CGFloat(IIMySceneZPosition.Scrolling.rawValue)
		self.addChild(spriteToScroll)
		
		//Overlay sprite to make anchor point 0,0 (lower left, default for SK)
		let spriteForScrollingGeometry = SKSpriteNode(color: SKColor.clearColor(), size: size)
		spriteForScrollingGeometry.anchorPoint = CGPointZero
		spriteForScrollingGeometry.position = CGPointMake(0, -size.height)
		spriteToScroll.addChild(spriteForScrollingGeometry)
		
		let spriteForStaticGeometry = SKSpriteNode(color: SKColor.clearColor(), size: size)
		spriteForStaticGeometry.anchorPoint = CGPointZero
		spriteForStaticGeometry.position = CGPointMake(0, -size.height)
		spriteForStaticGeometry.zPosition = CGFloat(IIMySceneZPosition.Static.rawValue)
		self.addChild(spriteForStaticGeometry)
		
		let spriteToHostHorizontalAndVerticalScrolling = SKSpriteNode(color: SKColor.clearColor(), size: size)
		spriteToHostHorizontalAndVerticalScrolling.anchorPoint = CGPointZero
		spriteToHostHorizontalAndVerticalScrolling.position = CGPointMake(0, -size.height)
		spriteToHostHorizontalAndVerticalScrolling.zPosition = CGFloat(IIMySceneZPosition.VerticalAndHorizontalScrolling.rawValue)
		self.addChild(spriteToHostHorizontalAndVerticalScrolling)

		var upAndDownSize = size
		upAndDownSize.width = 30
		let spriteForVerticalScrolling = SKSpriteNode(color: SKColor.clearColor(), size: upAndDownSize)
		spriteForVerticalScrolling.anchorPoint = CGPointZero
		spriteForVerticalScrolling.position = CGPointMake(0, 30)
		spriteToHostHorizontalAndVerticalScrolling.addChild(spriteForVerticalScrolling)

		var leftToRightSize = size
		leftToRightSize.height = 30
		let spriteForHorizontalScrolling = SKSpriteNode(color: SKColor.clearColor(), size: leftToRightSize)
		spriteForHorizontalScrolling.anchorPoint = CGPointZero
		spriteForHorizontalScrolling.position = CGPointMake(10, 0)
		spriteToHostHorizontalAndVerticalScrolling.addChild(spriteForHorizontalScrolling)
		
		//Test sprites for constrained Scrolling
		var labelPosition = CGFloat(-500.0)
		let stepSize = CGFloat(50.0)
		while labelPosition < 2000.0 {
			let labelText = String(format: "%5.0f", labelPosition)

			let hscrollingLabel = SKLabelNode(fontNamed: "HelveticaNeue")
			hscrollingLabel.text = labelText
			hscrollingLabel.fontSize = 14
			hscrollingLabel.fontColor = SKColor.darkGrayColor()
			hscrollingLabel.position = CGPointMake(0, labelPosition)
			hscrollingLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
			spriteForHorizontalScrolling.addChild(hscrollingLabel)

			let scrollingLabel = SKLabelNode(fontNamed: "HelveticaNeue")
			scrollingLabel.text = labelText
			scrollingLabel.fontSize = 14
			scrollingLabel.fontColor = SKColor.darkGrayColor()
			scrollingLabel.position = CGPointMake(labelPosition, 0)
			scrollingLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
			scrollingLabel.zPosition = CGFloat(IIMySceneZPosition.VerticalAndHorizontalScrolling.rawValue)
			spriteForVerticalScrolling.addChild(scrollingLabel)
			
			labelPosition += stepSize
		}

		//Test sprites for scrolling and zooming
		let greenTestSprite = SKSpriteNode(color: SKColor.greenColor(), size: CGSizeMake(size.width, size.height * 0.25))
		greenTestSprite.name = "greenTestSprite"
		greenTestSprite.anchorPoint = CGPointZero
		spriteForScrollingGeometry.addChild(greenTestSprite)
		
		let blueTestSprite = SKSpriteNode(color: SKColor.blueColor(), size: CGSizeMake(size.width * 0.25, size.height * 0.25))
		blueTestSprite.name = "blueTestSprite"
		blueTestSprite.anchorPoint = CGPointZero
		blueTestSprite.position = CGPointMake(size.width * 0.25, size.height * 0.65)
		spriteForScrollingGeometry.addChild(blueTestSprite)
		
		//Test sprites for stationary sprites
		let stationaryLabel = SKLabelNode(fontNamed: "HelveticaNeue")
		stationaryLabel.text = "I'm not gonna move, nope, nope."
		stationaryLabel.fontSize = 14
		stationaryLabel.fontColor = SKColor.darkGrayColor()
		stationaryLabel.position = CGPointMake(60, 80)
		stationaryLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
		spriteForStaticGeometry.addChild(stationaryLabel)
		
		
		//Set properties
		self.contentSize = size
		self.spriteToScroll = spriteToScroll
		self.spriteForScrollingGeometry = spriteForScrollingGeometry
		self.spriteForStaticGeometry = spriteForStaticGeometry
		self.spriteToHostHorizontalAndVerticalScrolling = spriteToHostHorizontalAndVerticalScrolling
		self.spriteForVerticalScrolling = spriteForVerticalScrolling
		self.spriteForHorizontalScrolling = spriteForHorizontalScrolling
		self.contentOffset = CGPointZero
	}

	required public init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override public func didChangeSize(oldSize: CGSize) {
		let size = self.size
		
		let lowerLeft = CGPointMake(0, -size.height)
		
		self.spriteForStaticGeometry?.size = size
		self.spriteForStaticGeometry?.position = lowerLeft
		
		self.spriteToHostHorizontalAndVerticalScrolling?.size = size
		self.spriteToHostHorizontalAndVerticalScrolling?.position = lowerLeft
	}
	
	func setContentScale(scale: CGFloat) {
		spriteToScroll?.setScale(scale)
		updateConstrainedScrollerSize()
	}
	
	func updateConstrainedScrollerSize() {
		let contentSize: CGSize = self.contentSize
		
		var verticalSpriteSize: CGSize = self.spriteForVerticalScrolling?.size ?? CGSizeZero
		verticalSpriteSize.height = contentSize.height
		spriteForVerticalScrolling?.size = verticalSpriteSize
		
		var horizontalSpriteSize = self.spriteForHorizontalScrolling?.size ?? CGSizeZero
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
