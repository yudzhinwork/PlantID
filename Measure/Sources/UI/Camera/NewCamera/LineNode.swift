//
//  LineNode.swift

import UIKit
import SceneKit

final class LineNode: SCNNode {
    
    // MARK: - Properties
    
    private let lineThickness = CGFloat(0.001)
    private let radius = CGFloat(0.1)
    private var boxGeometry: SCNBox!
    private var nodeLine: SCNNode!
    
    // MARK: - Life cycle

    init(from vectorA: SCNVector3, to vectorB: SCNVector3, lineColor color: UIColor, lineWidth width: CGFloat) {
        super.init()
        
        self.position = vectorA
        
        let nodeZAlign = SCNNode()
        nodeZAlign.eulerAngles.x = Float.pi/2
        
        let height = self.distance(from: vectorA, to: vectorB)
        boxGeometry = SCNBox(width: width, height: height, length: lineThickness, chamferRadius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = color
        boxGeometry.materials = [material]
        
        let nodeLine = SCNNode(geometry: boxGeometry)
        nodeLine.position.y = Float(-height/2) + 0.001
        self.nodeLine = nodeLine
        nodeZAlign.addChildNode(nodeLine)
        
        self.addChildNode(nodeZAlign)
        
        let orientationNode = SCNNode()
        orientationNode.position = vectorB
        self.constraints = [SCNLookAtConstraint(target: orientationNode)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Functions
    
    func distance(from vectorA: SCNVector3, to vectorB: SCNVector3) -> CGFloat {
        let x = (vectorA.x - vectorB.x) * (vectorA.x - vectorB.x)
        let y = (vectorA.y - vectorB.y) * (vectorA.y - vectorB.y)
        let z = (vectorA.z - vectorB.z) * (vectorA.z - vectorB.z)
        return CGFloat(sqrt(x + y + z))
    }
    
    func updateNode(vectorA: SCNVector3? = nil, vectorB: SCNVector3? = nil, color: UIColor?) {
        if let vectorA = vectorA, let vectorB = vectorB {
            let height = self.distance(from: vectorA, to: vectorB)
            boxGeometry.height = height
            nodeLine.position.y = Float(-height/2) + 0.001
            
            let orientationNode = SCNNode()
            orientationNode.position = vectorB
            self.constraints = [SCNLookAtConstraint(target: orientationNode)]
        }
        if let color = color {
            let material = SCNMaterial()
            material.diffuse.contents = color
            boxGeometry.materials = [material]
        }
    }
}
