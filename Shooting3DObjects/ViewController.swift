//
//  ViewController.swift
//  Shooting3DObjects
//
//  Created by Josh Bourke on 29/5/19.
//  Copyright © 2019 Josh Bourke. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        self.sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(self.sceneView)
        registerGestureRecognixer() 
    }
    
    private func registerGestureRecognixer(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func tapped(recognizer: UIGestureRecognizer){
        
        spawnShootyBalls()
        
    }
    
    private func spawnShootyBalls(){
        
        guard let currentFrame = self.sceneView.session.currentFrame else{
            return
        }
        
        //This will spawn the ball out in front of the camera instead of inside
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.1
        
        //Now to make the sphere Geometry
        let sphere = SCNSphere(radius: 0.4)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        sphere.materials = [material]
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereNode.physicsBody?.isAffectedByGravity = false
        
        
        let forceVector = SCNVector3(sphereNode.worldFront.x * 150, sphereNode.worldFront.y * 150, sphereNode.worldFront.z * 150)
        
        sphereNode.physicsBody?.applyForce(forceVector, asImpulse: true)
        
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
