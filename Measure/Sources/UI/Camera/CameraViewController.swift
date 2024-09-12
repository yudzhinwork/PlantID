import ARKit
import UIKit
import SwiftUI
import SceneKit

class CameraViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {

    // MARK: - Properties

    var delegateRouting: CameraRouterDelegate?
    var viewModel: CameraViewModel?

    var sceneView: ARSCNView!

    var pointNodeA: SCNNode?
    var pointNodeB: SCNNode?
    var lineNode: SCNNode?

    var choosePointNode: SCNNode?

    let session = ARSession()
    let vectorZero = SCNVector3()
    let sessionConfig = ARWorldTrackingConfiguration()
    var measuring = false
    var startValue = SCNVector3()
    var endValue = SCNVector3()

    private var distanceInInches: String = ""
    private var distanceInCm: String = ""

    @AppStorage("timesMeasured") var timesMeasured = 0
    // MARK: - Outlets

    private lazy var backButton: UIButton = {
        let button = IncreasedTapAreaButton()
        button.setImage(
            UIImage(named: "back-frame"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var pointButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "button-A"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(pointButtonTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let conteinerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.blackColor.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let addPointLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a point"
        label.textColor = Theme.whiteColor
        label.font = Fonts.regular.addFont(18)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let moveiPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Move iPhone to start"
        label.textColor = Theme.whiteColor
        label.font = Fonts.bold.addFont(20)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let choosePointImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "choosePoint")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var firstPointImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firstPoint")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)

        setupScene()

        setupNavigationBar()
        setupHierarchy()
        setupLayout()

        choosePointNode = createChoosePointNode()
        sceneView.scene.rootNode.addChildNode(choosePointNode!)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: backButton
        )
    }

    private func setupHierarchy() {
        view.addSubviews([
            pointButton,
            conteinerView,
            moveiPhoneLabel
        ])
        conteinerView.addSubview(
            addPointLabel
        )
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            pointButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            pointButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            pointButton.heightAnchor.constraint(
                equalToConstant: 84
            ),
            pointButton.widthAnchor.constraint(
                equalToConstant: 84
            ),

            conteinerView.bottomAnchor.constraint(
                equalTo: pointButton.topAnchor,
                constant: -24
            ),
            conteinerView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            conteinerView.widthAnchor.constraint(
                equalToConstant: 145
            ),
            conteinerView.heightAnchor.constraint(
                equalToConstant: 53
            ),

            addPointLabel.topAnchor.constraint(
                equalTo: conteinerView.topAnchor,
                constant: 16
            ),
            addPointLabel.leadingAnchor.constraint(
                equalTo: conteinerView.leadingAnchor,
                constant: 24
            ),
            addPointLabel.trailingAnchor.constraint(
                equalTo: conteinerView.trailingAnchor,
                constant: -24
            ),
            addPointLabel.bottomAnchor.constraint(
                equalTo: conteinerView.bottomAnchor,
                constant: -16
            ),

            moveiPhoneLabel.bottomAnchor.constraint(
                equalTo: conteinerView.topAnchor, 
                constant: -116
            ),
            moveiPhoneLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            )
        ])
    }

    func createChoosePointNode() -> SCNNode {
        let plane = SCNPlane(width: 0.1, height: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = choosePointImageView.image
        plane.materials = [material]

        let node = SCNNode(geometry: plane)
        return node
    }

    func session(
        _ session: ARSession,
        cameraDidChangeTrackingState camera: ARCamera
    ) {
        switch camera.trackingState {
        case .normal: moveiPhoneLabel.isHidden = true
        default: moveiPhoneLabel.isHidden = false
        }
    }

    func lineBetweenNodes(
        positionA: SCNVector3,
        positionB: SCNVector3,
        inScene: SCNScene
    ) -> SCNNode {
        let vector = SCNVector3(
            positionA.x - positionB.x,
            positionA.y - positionB.y,
            positionA.z - positionB.z
        )
        let distance = sqrt(
            vector.x * vector.x
            + vector.y * vector.y
            + vector.z * vector.z
        )
        let midPosition = SCNVector3(
            (positionA.x + positionB.x) / 2,
            (positionA.y + positionB.y) / 2,
            (positionA.z + positionB.z) / 2
        )

        let lineGeometry = SCNCylinder()
        lineGeometry.radius = 0.001
        lineGeometry.height = CGFloat(distance)
        lineGeometry.radialSegmentCount = 5
        lineGeometry.firstMaterial!.diffuse.contents = Theme.whiteColor

        let lineNode = SCNNode(geometry: lineGeometry)
        lineNode.position = midPosition
        lineNode.look(
            at: positionB,
            up: inScene.rootNode.worldUp,
            localFront: lineNode.worldUp
        )
        return lineNode
    }

    func setupScene() {
        sceneView.delegate = self
        sceneView.session = session
        session.run(
            sessionConfig,
            options: [
                .resetTracking,
                .removeExistingAnchors
            ]
        )
        resetValues()
    }

    func resetValues() {
        measuring = false
        startValue = SCNVector3()
        endValue =  SCNVector3()
        pointNodeA?.removeFromParentNode()
        pointNodeB?.removeFromParentNode()
        lineNode?.removeFromParentNode()

        updateResultLabel(0.0)
    }

    func updateResultLabel(_ value: Float) {
        let cm = value * 100.0
        let inch = cm * 0.3937007874
        distanceInInches = String(format: "%.2f\"", inch)
        distanceInCm = String(format: "%.2f cm", cm)

        print(String(format: "%.2f cm / %.2f\"", cm, inch))
    }

    func createPointNode(color: UIColor) -> SCNNode {
        let sphereGeometry = SCNSphere(radius: 0.003)
        let material = SCNMaterial()
        material.diffuse.contents = color
        sphereGeometry.materials = [material]

        let node = SCNNode(geometry: sphereGeometry)
        return node
    }

    func detectObjects() {
        if let worldPos = sceneView.realWorldVector(screenPos: view.center) {
            choosePointNode?.simdWorldPosition = simd_float3(
                worldPos.x, worldPos.y, worldPos.z
            )
            
            if measuring {
                if startValue == vectorZero {
                    startValue = worldPos
                }
                endValue = worldPos
                updateResultLabel(
                    startValue.distance(
                        from: endValue
                    )
                )
            }
        }
    }

    // MARK: - Actions

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func pointButtonTapped() {
//        if PremiumManager.shared.isUserPremium {
//            pointButtonTap()
//        } else {
//            if timesMeasured > 2 {
//                delegateRouting?.routeToTrial()
//            } else {
//                pointButtonTap()
//            }
//        }
    }
        
    private func pointButtonTap() {
        if pointButton.currentImage == UIImage(named: "button-A") {
            resetValues()
            measuring = true

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("Trying to set pointNodeA")

                let hitTestResults = sceneView.hitTest(
                    sceneView.center,
                    types: [
                        .estimatedHorizontalPlane,
                        .estimatedVerticalPlane
                    ]
                )
                guard let results = hitTestResults.first else { return }

                // Use the first result to set the pointNodeA
                let worldCoordinates = simd_float3(
                    x: results.worldTransform.columns.3.x,
                    y: results.worldTransform.columns.3.y,
                    z: results.worldTransform.columns.3.z
                )
                // Create a white point node and add it to the scene
                let whitePointNode = self.createPointNode(color: UIColor.white)
                self.sceneView.scene.rootNode.addChildNode(whitePointNode)
                whitePointNode.simdWorldPosition = worldCoordinates

                self.pointNodeA = whitePointNode
                print("pointNodeA set successfully")
            }

            // Toggle to "button-B" image
            pointButton.setImage(UIImage(named: "button-B"), for: .normal)
        } else {
            measuring = false

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                let hitTestResults = sceneView.hitTest(
                    sceneView.center,
                    types: [
                        .estimatedHorizontalPlane,
                        .estimatedVerticalPlane
                    ]
                )
                guard let results = hitTestResults.first else { return }

                let worldCoordinates = simd_float3(
                    x: results.worldTransform.columns.3.x,
                    y: results.worldTransform.columns.3.y,
                    z: results.worldTransform.columns.3.z
                )

                // Create a white point node and add it to the scene
                let whitePointNode = self.createPointNode(color: UIColor.white)
                self.sceneView.scene.rootNode.addChildNode(whitePointNode)
                whitePointNode.simdWorldPosition = worldCoordinates

                self.pointNodeB = whitePointNode
                print("pointNodeB set successfully")

                // Remove the temporary line
                self.lineNode?.removeFromParentNode()
                self.lineNode = nil

                // Draw a line between pointA and pointB
                if let pointA = self.pointNodeA, let pointB = self.pointNodeB {
                    let lineNode = self.lineBetweenNodes(
                        positionA: pointA.worldPosition,
                        positionB: pointB.worldPosition,
                        inScene: self.sceneView.scene
                    )
                    lineNode.geometry?.materials.first?.readsFromDepthBuffer = false

                    self.sceneView.scene.rootNode.addChildNode(lineNode)
                    self.lineNode = lineNode
                }
            }

            // Toggle to "button-A" image
            pointButton.setImage(UIImage(named: "button-A"), for: .normal)

//            let viewController = ResultViewController(
//                distanceInInches: distanceInInches,
//                distanceInCm: distanceInCm
//            )
//            viewController.isModalInPresentation = true
//
//            if let sheet = viewController.sheetPresentationController {
//                sheet.detents = [.medium()]
//            }
//
//            present(viewController, animated: true)
        }
    }
}

// MARK: - SCNVector3

extension SCNVector3: Equatable {
    static func positionFromTransform(
        _ transform: matrix_float4x4
    ) -> SCNVector3 {
        return SCNVector3Make(
            transform.columns.3.x,
            transform.columns.3.y,
            transform.columns.3.z
        )
    }

    func distance(from vector: SCNVector3) -> Float {
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z

        return sqrtf(
            (distanceX * distanceX)
            + (distanceY * distanceY)
            + (distanceZ * distanceZ)
        )
    }

    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}

// MARK: - ARSCNView

extension ARSCNView {
    func realWorldVector(screenPos: CGPoint) -> SCNVector3? {
        let planeTestResults = self.hitTest(
            screenPos, types: [.featurePoint]
        )
        if let result = planeTestResults.first {
            return SCNVector3.positionFromTransform(
                result.worldTransform
            )
        }
        return nil
    }
}

// MARK: - ARSCNViewDelegate

extension CameraViewController {
    func renderer(
        _ renderer: SCNSceneRenderer,
        updateAtTime time: TimeInterval
    ) {
        DispatchQueue.main.async {
            self.detectObjects()

            // Update the position of choosePointNode based on hit test results
            if let hitTestResult = self.hitTestChoosePointNode() {
                let worldCoordinates = SCNVector3.positionFromTransform(
                    hitTestResult.worldTransform
                )
                self.choosePointNode?.simdWorldPosition = simd_float3(
                    worldCoordinates.x, worldCoordinates.y, worldCoordinates.z
                )
            }
        }
    }

    private func hitTestChoosePointNode() -> ARHitTestResult? {
        guard let choosePointNode = choosePointNode else {
            return nil
        }
        let screenPos = sceneView.convert(
            choosePointImageView.center,
            from: view
        )
        let hitTestResults = sceneView.hitTest(
            screenPos,
            types: [
                .existingPlaneUsingExtent,
                .estimatedVerticalPlane,
                .estimatedHorizontalPlane
            ]
        )
        return hitTestResults.first
    }
}
