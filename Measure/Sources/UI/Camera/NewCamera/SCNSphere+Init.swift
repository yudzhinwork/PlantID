//
//  SCNSphere+Init.swift

import Foundation
import SceneKit

extension SCNSphere {
    
    convenience init(color: UIColor, radius: CGFloat) {
        self.init(radius: radius)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        materials = [material]
    }
}
