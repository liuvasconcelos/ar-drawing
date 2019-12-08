//
//  ViewController.swift
//  AR Drawing
//
//  Created by Livia Vasconcelos on 08/12/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                       ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.showsStatistics = true
        self.sceneView.delegate = self
        self.sceneView.session.run(configuration)
    }

    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let transform  = pointOfView.transform
        //get orientation of the camera
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        //get location of the camera
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location
        
        DispatchQueue.main.async {
            if self.drawButton.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name     = "pointer"
                pointer.position = currentPositionOfCamera

                self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                }

                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
       
    }

    @IBAction func draw(_ sender: Any) {
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

