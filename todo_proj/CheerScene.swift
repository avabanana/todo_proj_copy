import Foundation
import SpriteKit

class CheerScene: SKScene {
    private var sprite: SKSpriteNode?
    private var frames: [SKTexture] = []
    private let animationKey = "cheerAnimation"
    private var breakFrame: SKTexture?

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        
        let texture = SKTexture(imageNamed: "cheer_spritesheet")
        let columns = 4
        let rows = 2
        let totalFrames = 8
        let missingFrameIndex = 7

        let frameWidth = texture.size().width / CGFloat(columns)
        let frameHeight = texture.size().height / CGFloat(rows)

        var loadedFrames: [SKTexture] = []

        for row in 0..<rows {
            for column in 0..<columns {
                let index = row * columns + column
                if index == missingFrameIndex { continue }

                let rect = CGRect(
                    x: CGFloat(column) * frameWidth / texture.size().width,
                    y: CGFloat(rows - 1 - row) * frameHeight / texture.size().height,
                    width: frameWidth / texture.size().width,
                    height: frameHeight / texture.size().height
                )

                loadedFrames.append(SKTexture(rect: rect, in: texture))
            }
        }

        self.frames = loadedFrames
        self.breakFrame = loadedFrames.first // You can choose any frame here for break time

        let spriteNode = SKSpriteNode(texture: frames.first)
        spriteNode.setScale(0.2)
        spriteNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        self.sprite = spriteNode
        addChild(spriteNode)

        startAnimation()
    }

    func startAnimation() {
        guard !frames.isEmpty else { return }
        let animation = SKAction.repeatForever(
            SKAction.animate(with: frames, timePerFrame: 0.23)
        )
        sprite?.run(animation, withKey: animationKey)
    }

    func stopAnimationAtBreakFrame() {
        sprite?.removeAction(forKey: animationKey)
        if let breakFrame = breakFrame {
            sprite?.texture = breakFrame
        }
    }
}
