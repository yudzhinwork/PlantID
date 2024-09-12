////
////  ViewController.swift
//
//import UIKit
//import ARKit
//import RealityKit
//import SwiftUI
//
//fileprivate struct FloorRect {
//    var length: CGFloat
//    var breadth: CGFloat
//    var area: CGFloat {
//        return length * breadth
//    }
//}
//
//fileprivate enum MeasureState {
//    case length
//    case width
//}
//
//final class AreaViewController: BaseViewController {
//
//    // MARK: - UI Components
//
//    fileprivate lazy var historyButton: UIButton = {
//        let button = IncreasedTapAreaButton()
//        button.setImage(UIImage(named: "NavigationButton-History"),for: .normal)
//        button.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    fileprivate lazy var settingsButton: UIButton = {
//        let button = IncreasedTapAreaButton()
//        button.setImage(UIImage(named: "NavigationButton-Settings"),for: .normal)
//        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    fileprivate let addPointLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Add a point"
//        label.textColor = Theme.whiteColor
//        label.font = Fonts.regular.addFont(18)
//        label.textAlignment = .center
//        label.numberOfLines = 1
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    fileprivate let conteinerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Theme.blackColor.withAlphaComponent(0.3)
//        view.layer.cornerRadius = 12
//        view.clipsToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    fileprivate let centerPointImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "middlePoint")!
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    fileprivate lazy var pointButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "button-A"), for: .normal)
//        button.addTarget(self, action: #selector(addPoint), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    fileprivate lazy var saveToHistoryButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "HistoryButton"), for: .normal)
//        button.addTarget(self, action: #selector(saveToHistory), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    fileprivate lazy var resetButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "Reset"), for: .normal)
//        button.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    // MARK: - Properties
//
//    fileprivate var distanceInInches = ""
//    fileprivate var distanceInCm = ""
//    fileprivate var floorRect = FloorRect(length: 0, breadth: 0)
//    fileprivate var lengthNodes = NSMutableArray()
//    fileprivate var widthNodes = NSMutableArray()
//    fileprivate var lineNodes = NSMutableArray()
//    fileprivate var currentState: MeasureState = .length
//    fileprivate let lineWidth = CGFloat(0.003)
//    fileprivate let nodeRadius = CGFloat(0.015)
//    fileprivate let realTimeLineName = "realTimeLine"
//    fileprivate var realTimeLineNode: LineNode?
//    fileprivate var sceneView: MeasureSCNView!
//    fileprivate var distanceTextNode: SCNNode?
//
//    var delegateRouting: CameraRouterDelegate?
//
//    @AppStorage("timesMeasured") var timesMeasured = 0
//    
//    var allPointNodes: [Any] {
//        get {
//            return lengthNodes as! [Any] + widthNodes
//        }
//    }
//
//    var nodeColor: UIColor {
//        return nodeColorFor(currentState)
//    }
//
//    lazy var screenCenterPoint: CGPoint = {
//        return centerPointImageView.center
//    }()
//
//    // MARK: - Life cycle
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        resetMeasurement()
//        checkCameraAccessAndSetupSession()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        sceneView.pause()
//        super.viewWillDisappear(animated)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        sceneView = MeasureSCNView(frame: view.bounds)
//        view.addSubview(sceneView)
//        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
//        sceneView.delegate = self
//
//        setupNavigationBar()
//        setupHierarchy()
//        setupLayout()
//
//        setupARSession()
//    }
//
//    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        } else {
//            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        }
//    }
//
//    //MARK: - IBActions
//
//    @objc func saveToHistory(_ sender: UIButton) {
//        if !PremiumManager.shared.isUserPremium {
//            premiumButtonTapped()
//        } else {
//            guard let screenshot = captureScreen() else {
//                print("Failed to capture screenshot")
//                return
//            }
//
//            let viewController = HistoryDataViewController(image: screenshot, date: Date())
//            viewController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//    }
//
//    @objc func resetAction(_ sender: UIButton) {
//        if !PremiumManager.shared.isUserPremium {
//            premiumButtonTapped()
//        } else {
//            resetMeasurement()
//        }
//    }
//
//    @objc func historyButtonTapped() {
//        if !PremiumManager.shared.isUserPremium {
//            premiumButtonTapped()
//        } else {
//            let historyViewController = HistoryViewController()
//            historyViewController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(historyViewController, animated: true)
//        }
//    }
//
//    @objc func settingsButtonTapped() {
//        let settingsViewController = SettingsViewController()
//        settingsViewController.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(settingsViewController, animated: true)
//    }
//
//    @IBAction func addPoint(_ sender: UIButton) {
//        if !PremiumManager.shared.isUserPremium {
//            premiumButtonTapped()
//        } else {
//            let pointLocation = view.convert(screenCenterPoint, to: sceneView)
//
//            guard let hitResultPosition = sceneView.hitResult(forPoint: pointLocation) else {
//                return
//            }
//
//            sender.isUserInteractionEnabled = false
//            defer {
//                sender.isUserInteractionEnabled = true
//            }
//
//            let nodes = nodesList(forState: currentState)
//
//            let sphere = SCNSphere(color: nodeColor, radius: nodeRadius)
//            let node = SCNNode(geometry: sphere)
//            node.position = hitResultPosition
//            sceneView.scene.rootNode.addChildNode(node)
//
//            nodes.add(node)
//
//            conteinerView.isHidden = true
//
//            if nodes.count > 1 {
//                let previousNode = nodes[nodes.count - 2] as! SCNNode
//                let currentNode = nodes[nodes.count - 1] as! SCNNode
//
//                let measureLine = LineNode(
//                    from: previousNode.position,
//                    to: currentNode.position,
//                    lineColor: nodeColor,
//                    lineWidth: lineWidth
//                )
//                sceneView.scene.rootNode.addChildNode(measureLine)
//                lineNodes.add(measureLine)
//
//                let distance = sceneView.distance(betweenPoints: previousNode.position, point2: currentNode.position)
//
//                addDistanceTextNode(from: previousNode.position, to: currentNode.position, distance: Float(distance))
//
//                updateResultLabel(Float(distance))
//            }
//
//            if nodes.count > 0 {
//                let lastNode = nodes.lastObject as! SCNNode
//                realTimeLineNode = LineNode(
//                    from: lastNode.position,
//                    to: hitResultPosition,
//                    lineColor: nodeColor,
//                    lineWidth: lineWidth
//                )
//                sceneView.scene.rootNode.addChildNode(realTimeLineNode!)
//            }
//        }
//    }
//}
//
//// MARK: - Private
//
//private extension AreaViewController {
//
//    private func addDistanceTextNode(from startPosition: SCNVector3, to endPosition: SCNVector3, distance: Float) {
//        let midPosition = SCNVector3(
//            (startPosition.x + endPosition.x) / 2,
//            (startPosition.y + endPosition.y) / 2,
//            (startPosition.z + endPosition.z) / 2
//        )
//        let convertedDistance = convertDistance(distance)
//        let distanceText = String(format: "%.2f %@", convertedDistance.value, convertedDistance.unit)
//        let textGeometry = SCNText(string: distanceText, extrusionDepth: 0.05)
//        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
//        textGeometry.font = UIFont.systemFont(ofSize: 1)
//
//        textGeometry.alignmentMode = CATextLayerAlignmentMode.center.rawValue
//        textGeometry.firstMaterial?.isDoubleSided = true
//
//        let textNode = SCNNode(geometry: textGeometry)
//        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
//
//        textNode.position = SCNVector3(midPosition.x, midPosition.y, midPosition.z)
//        textNode.constraints = [SCNBillboardConstraint()]
//
//        sceneView.scene.rootNode.addChildNode(textNode)
//        distanceTextNode = textNode
//    }
//
//    private func convertDistance(_ distanceInMeters: Float) -> (value: Float, unit: String) {
//        return (0,"")
//    }
//
//    private func captureScreen() -> UIImage? {
//        let bounds = sceneView.bounds
//        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
//        sceneView.drawHierarchy(in: bounds, afterScreenUpdates: true)
//        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return snapshot
//    }
//
//    private func setupARSession() {
//        let configuration = ARWorldTrackingConfiguration()
//
//        if isLiDARSupported() {
//            configuration.frameSemantics = .sceneDepth
//            configuration.sceneReconstruction = .meshWithClassification
//            configuration.environmentTexturing = .automatic
//        }
//
//        sceneView.session.run(configuration)
//    }
//
//    private func checkCameraAccessAndSetupSession() {
//        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                if granted {
//                    self.setupARSession()
//                } else {
//                    self.showCameraAccessDeniedAlert()
//                }
//            }
//        }
//    }
//
//    private func showCameraAccessDeniedAlert() {
//        let alertController = UIAlertController(
//            title: "Camera Access Denied",
//            message: "To use this app, please allow access to your camera in Settings.",
//            preferredStyle: .alert
//        )
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
//            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(settingsUrl)
//            }
//        }))
//        present(alertController, animated: true, completion: nil)
//    }
//
//    func setupHierarchy() {
//        view.addSubviews([
//            resetButton,
//            pointButton,
//            saveToHistoryButton,
//            centerPointImageView,
//            conteinerView
//        ])
//        conteinerView.addSubview(
//            addPointLabel
//        )
//    }
//
//    func setupNavigationBar() {
////        title = "Measure"
////        navigationItem.leftBarButtonItem = UIBarButtonItem(
////            customView: historyButton
////        )
////        navigationItem.rightBarButtonItem = UIBarButtonItem(
////            customView: settingsButton
////        )
//    }
//
//    private func setupLayout() {
//        NSLayoutConstraint.activate([
//            pointButton.bottomAnchor.constraint(
//                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
//                constant: -16
//            ),
//            pointButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            pointButton.heightAnchor.constraint(equalToConstant: 84),
//            pointButton.widthAnchor.constraint(equalToConstant: 84),
//            saveToHistoryButton.centerYAnchor.constraint(equalTo: pointButton.centerYAnchor),
//            saveToHistoryButton.leadingAnchor.constraint(
//                equalTo: pointButton.trailingAnchor,
//                constant: 32
//            ),
//            saveToHistoryButton.heightAnchor.constraint(equalToConstant: 52),
//            saveToHistoryButton.widthAnchor.constraint(equalToConstant: 52),
//
//            resetButton.centerYAnchor.constraint(equalTo: pointButton.centerYAnchor),
//            resetButton.trailingAnchor.constraint(
//                equalTo: pointButton.leadingAnchor,
//                constant: -32
//            ),
//            resetButton.heightAnchor.constraint(equalToConstant: 52),
//            resetButton.widthAnchor.constraint(equalToConstant: 52),
//
//            conteinerView.bottomAnchor.constraint(
//                equalTo: pointButton.topAnchor,
//                constant: -24
//            ),
//            conteinerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            conteinerView.widthAnchor.constraint(equalToConstant: 145),
//            conteinerView.heightAnchor.constraint(equalToConstant: 53),
//            addPointLabel.topAnchor.constraint(
//                equalTo: conteinerView.topAnchor,
//                constant: 16
//            ),
//            addPointLabel.leadingAnchor.constraint(
//                equalTo: conteinerView.leadingAnchor,
//                constant: 24
//            ),
//            addPointLabel.trailingAnchor.constraint(
//                equalTo: conteinerView.trailingAnchor,
//                constant: -24
//            ),
//            addPointLabel.bottomAnchor.constraint(
//                equalTo: conteinerView.bottomAnchor,
//                constant: -16
//            ),
//            centerPointImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            centerPointImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            centerPointImageView.widthAnchor.constraint(equalToConstant: 64),
//            centerPointImageView.heightAnchor.constraint(equalToConstant: 64)
//        ])
//    }
//
//    func nodeColorFor(_ state: MeasureState) -> UIColor {
//        switch state {
//        case .length: .white
//        case .width: .red
//        }
//    }
//
//    func isLiDARSupported() -> Bool {
//        return ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth)
//    }
//
//    func updateResultLabel(_ value: Float) {
//        let cm = value * 100.0
//        let inch = cm * 0.3937007874
//        distanceInInches = String(format: "%.2f\"", inch)
//        distanceInCm = String(format: "%.2f cm", cm)
//    }
//
//    func nodesList(forState state: MeasureState) -> NSMutableArray {
//        switch state {
//        case .length:
//            return lengthNodes
//        case .width:
//            return widthNodes
//        }
//    }
//
//    func clearScene() {
//        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
//            node.removeFromParentNode()
//        }
//        lengthNodes.removeAllObjects()
//        widthNodes.removeAllObjects()
//        lineNodes.removeAllObjects()
//        distanceTextNode?.removeFromParentNode()
//        distanceTextNode = nil
//        realTimeLineNode?.removeFromParentNode()
//        realTimeLineNode = nil
//    }
//
//    func resetMeasurement() {
//        clearScene()
//        floorRect = FloorRect(length: 0, breadth: 0)
//        currentState = .length
//        lengthNodes = []
//        widthNodes = []
//        lineNodes = []
//        distanceTextNode?.removeFromParentNode()
//        distanceTextNode = nil
//        conteinerView.isHidden = false
//    }
//
//    func removeNodes(_ nodes: NSMutableArray) {
//        for node in nodes {
//            if let node = node as? SCNNode {
//                node.removeFromParentNode()
//                nodes.remove(node)
//            }
//        }
//        nodes.removeAllObjects()
//    }
//
//    func updateScaleFromCameraForNodes(_ nodes: [SCNNode], fromPointOfView pointOfView: SCNNode){
//        nodes.forEach { (node) in
//            let positionOfNode = SCNVector3ToGLKVector3(node.worldPosition)
//            let positionOfCamera = SCNVector3ToGLKVector3(pointOfView.worldPosition)
//            let distanceBetweenNodeAndCamera = GLKVector3Distance(positionOfNode, positionOfCamera)
//
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 0.5
//            switch distanceBetweenNodeAndCamera {
//            case 0 ... 0.5:
//                node.simdScale = simd_float3(0.25, 0.25, 0.25)
//            case 0.5 ... 1.5:
//                node.simdScale = simd_float3(0.5, 0.5, 0.5)
//            case 1.5 ... 2.5:
//                node.simdScale = simd_float3(1, 1, 1)
//            case 2.5 ... 3:
//                node.simdScale = simd_float3(1.5, 1.5, 1.5)
//            case 3 ... 3.5:
//                node.simdScale = simd_float3(2, 2, 2)
//            case 3.5 ... 5:
//                node.simdScale = simd_float3(2.5, 2.5, 2.5)
//            default:
//                node.simdScale = simd_float3(3, 3, 3)
//            }
//            SCNTransaction.commit()
//        }
//    }
//}
//
//// MARK: - ARSCNViewDelegate
//
//extension AreaViewController: ARSCNViewDelegate {
//
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        let dotNodes = allPointNodes as! [SCNNode]
//        if dotNodes.count > 0, let currentCameraPosition = self.sceneView.pointOfView {
//            updateScaleFromCameraForNodes(dotNodes, fromPointOfView: currentCameraPosition)
//        }
//
//        if let realTimeLineNode = self.realTimeLineNode,
//           let hitResultPosition = sceneView.hitResult(forPoint: screenCenterPoint),
//           let lastNode = self.nodesList(forState: self.currentState).lastObject as? SCNNode {
//
//            realTimeLineNode.updateNode(vectorA: lastNode.position, vectorB: hitResultPosition, color: .white)
//        }
//    }
//}
//
//// MARK: - CustomTrialViewDelegate
//
//extension AreaViewController: CustomTrialViewDelegate {
//
//    func premiumButtonTapped() {
//        let paywallViewController = PaywallViewController()
//        paywallViewController.modalPresentationStyle = .overFullScreen
//        paywallViewController.modalTransitionStyle = .crossDissolve
//        self.present(paywallViewController, animated: true)
//    }
//}
