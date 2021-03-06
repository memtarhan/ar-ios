//
//  ViewController.swift
//  SampleApp
//
//  Created by Mehmet Tarhan on 27.09.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var xPositionSlider: UISlider!
    @IBOutlet weak var xPositionLabel: UILabel!
    @IBOutlet weak var yPositionSlider: UISlider!
    @IBOutlet weak var yPositionLabel: UILabel!
    @IBOutlet weak var zPositionSlider: UISlider!
    @IBOutlet weak var zPositionLabel: UILabel!
    
    private var configuration: ARWorldTrackingConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set debug options -> showing world origin
        sceneView.debugOptions = [.showWorldOrigin]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func resetButtonDidTap(_ sender: Any) {
        resetWorldOrigin()
    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        let position = SCNVector3(xPositionSlider.value, yPositionSlider.value, zPositionSlider.value)
        displayShape(at: position)
    }
    
    @IBAction func slideDidChange(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            // X position
            xPositionLabel.text = "\(sender.value)"
        case 1:
            // Y position
            yPositionLabel.text = "\(sender.value)"
        case 2:
            // Z position
            zPositionLabel.text = "\(sender.value)"
        default:
            break
        }
    }
    
    // MARK: - Resetting the World Origin
    private func resetWorldOrigin() {
        print(#function)

        sceneView.session.pause()
        // Remove nodes named "sphere"
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "sphere" {
                node.removeFromParentNode()
            }
        }
        sceneView.session.run(configuration, options: [.resetTracking])
    }
    
    // MARK: - Displaying Shapes at Coordinates
    private func displayShape(at coordinates: SCNVector3) {
        // Create a 3D shape(Sphere)
        let sphere = SCNSphere(radius: 0.06)
        // Set the looks of the shape
        sphere.firstMaterial?.diffuse.contents = UIColor.purple
        // Create a node with the shape
        let node = SCNNode(geometry: sphere)
        // Set location of the node
        node.position = coordinates
        // Set name of the node
        node.name = "sphere"
        
        // Add the node to sceneView
        sceneView.scene.rootNode.addChildNode(node)
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print(#function)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print(#function)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print(#function)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(#function)
    }
}
