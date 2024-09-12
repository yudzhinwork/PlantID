//

import UIKit
import ARKit

open class MeasureSCNView: ARSCNView {
    
    private var configuration = ARWorldTrackingConfiguration()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public override init(frame: CGRect, options: [String: Any]? = nil) {
        super.init(frame: frame, options: options)
        setUp()
    }
    
    //MARK: - Private helper methods
    
    private func setUp() {
        let scene = SCNScene()
        
        self.automaticallyUpdatesLighting = true
        self.scene = scene
        configuration.planeDetection = [.horizontal, .vertical]
    }
    
    //MARK: - Public
    
    func run() {
        self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func pause() {
        self.session.pause()
    }
    
    func hitResult(forPoint point: CGPoint) -> SCNVector3? {
        
        let hitTypes: ARHitTestResult.ResultType = [
            .featurePoint,
            .estimatedHorizontalPlane,
            .estimatedVerticalPlane, 
            .existingPlaneUsingExtent
        ]
        
        let hitTestResults = hitTest(point, types: hitTypes)
        if let result = hitTestResults.first {
            let vector = result.worldTransform.columns.3
            return SCNVector3(vector.x, vector.y, vector.z)
        } else {
            return nil
        }
    }
    
    func distance(betweenPoints point1: SCNVector3, point2: SCNVector3) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        let dz = point2.z - point1.z
        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }
}
