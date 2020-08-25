//
//  ViewController.swift
//  ChangeMyFace
//
//  Created by 村尾慶伸 on 2020/08/25.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!

    private var faceGeometry: ARSCNFaceGeometry!
    private let faceNode = SCNNode()

    private let photos: [String] = ["kabuki"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard ARFaceTrackingConfiguration.isSupported else { fatalError("Not supported") }
        
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.scene = SCNScene()

        updateFaceGeometry()

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


    private func updateFaceGeometry() {
        let device = sceneView.device!
        faceGeometry = ARSCNFaceGeometry(device: device, fillMesh: true)
        if let material = faceGeometry.firstMaterial {
            material.diffuse.contents = UIColor.blue
            material.lightingModel = .physicallyBased

            let kabuki = UIImage(named: "kabuki")!
            material.diffuse.contents = kabuki

        }
        faceNode.geometry = faceGeometry
    }

}


extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        faceGeometry.update(from: faceAnchor.geometry)
        node.addChildNode(faceNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        faceGeometry.update(from: faceAnchor.geometry)
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let cellImage = UIImage(named: photos[indexPath.row])
        imageView.image = cellImage

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = self.view.bounds.width / 4
        return CGSize(width: cellSize, height: cellSize)
    }

}
