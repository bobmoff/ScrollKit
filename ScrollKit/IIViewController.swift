//
// ScrollKit 
// https://github.com/bobmoff/ScrollKit
// Created by Fille Åström
//

import SpriteKit

typealias KVOContext = UInt8
var ViewTransformChangedObservationContext = KVOContext()

@objc(IIViewController) class IIViewController: UIViewController, UIScrollViewDelegate {

	weak var scene: IIMyScene?
	weak var clearContentView: UIView?
	weak var scrollView: UIScrollView?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Configure the view.
		let skView = self.view as! SKView
		skView.showsFPS = true
		skView.showsNodeCount = true
		
		// Create and configure the scene.
		let scene = IIMyScene(size: skView.bounds.size)
		scene.scaleMode = .fill
		
		// Present the scene.
		skView.presentScene(scene)
		self.scene = scene
		
		var contentSize = skView.frame.size
		contentSize.width *= 1.5
		contentSize.height *= 1.5
		scene.contentSize = contentSize
		
		let scrollView = UIScrollView(frame: CGRect.zero)
		scrollView.contentSize = contentSize
		scrollView.delegate = self
		scrollView.minimumZoomScale = 1
		scrollView.maximumZoomScale = 3
		scrollView.indicatorStyle = .white
		self.scrollView = scrollView
		
        let clearContentView = UIView(frame: CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
		clearContentView.backgroundColor = UIColor.clear
		scrollView.addSubview(clearContentView)
		self.clearContentView = clearContentView
	
		clearContentView.addObserver(self, forKeyPath: "transform", options: .new, context: &ViewTransformChangedObservationContext)
		skView.addSubview(scrollView)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		scrollView?.frame = view.bounds
		scene?.size = view.bounds.size
		if let scrollView = scrollView {
			adjustContent(scrollView: scrollView)
		}
	}
	
	func adjustContent(scrollView: UIScrollView) {
		let zoomScale = scrollView.zoomScale
		scene?.setContentScale(scale: zoomScale)
		let contentOffset = scrollView.contentOffset
		let contentSize = scrollView.contentSize
		let scrollAreaHeight: CGFloat = contentSize.height - scrollView.bounds.height
		let yUIKit: CGFloat = contentOffset.y
		
		// Convert from UIKit coordinates to SpriteKit coordinates
		// UIKit has 0,0 in the top-left corner
		// SpriteKit has 0,0 in the bottom-left corner
		let ySpriteKit = scrollAreaHeight - yUIKit
        let contentOffsetSpriteKit = CGPoint(x: contentOffset.x, y: ySpriteKit)
		scene?.contentOffset = contentOffsetSpriteKit
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustContent(scrollView: scrollView)
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return clearContentView
	}
	
	func scrollViewDidTransform(scrollView: UIScrollView) {
        adjustContent(scrollView: scrollView)
	}
	
	// scale between minimum and maximum. called after any 'bounce' animations
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        adjustContent(scrollView: scrollView)
	}

	// MARK: KVO
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if context == &ViewTransformChangedObservationContext {
			if let view = object as? UIView, let scrollView = view.superview as? UIScrollView {
				scrollViewDidTransform(scrollView: scrollView)
				return
			}
		}
        super.observeValue(forKeyPath: keyPath, of: object, change: change , context: context)
	}
	
	deinit {
		clearContentView?.removeObserver(self, forKeyPath: "transform", context: &ViewTransformChangedObservationContext)
	}
	
}
