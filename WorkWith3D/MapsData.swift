//
//  MapsData.swift
//  WorkWith3D
//
//  Created by Anatolich Mixaill on 18.07.2022.
//

import Foundation
import UIKit
import RealityKit
import ARKit
var UseServer=WorkWithServer()

//Получаем ссылку сохранения на устройстве
var mapSaveURL: URL = {
    do {
        return try FileManager.default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent("mapdrone.arexperience")
    } catch {
        fatalError("Can't get file save URL: \(error.localizedDescription)")
    }
}()

//var worldMapURL: URL = {
//    do {
//        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            .appendingPathComponent("worldMapURL")
//    } catch {
//        fatalError("Error getting world map URL from document directory.")
//    }
//}()
//Сохраняем данные карты на устройстве по ссылке
func saveExperience(sceneView: ARView) {
//    sceneView.session.getCurrentWorldMap { worldMap, error in
//        guard let map = worldMap
//            else {
//            print("Can't get current world map")
////            fatalError("Can't get current world map: \(error!.localizedDescription)")
////            .showAlert(title: "Can't get current world map", message: error!.localizedDescription);
//            return }
//
//        // Add a snapshot image indicating where the map was captured.
//        guard let snapshotAnchor = SnapshotAnchor(capturing: sceneView)
//            else { fatalError("Can't take snapshot") }
//        map.anchors.append(snapshotAnchor)
//
//        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
//            try data.write(to: mapSaveURL, options: [.atomic])
//            print("Data was saved")
////            DispatchQueue.main.async {
//////                self.loadExperienceButton.isHidden = false
//////                self.loadExperienceButton.isEnabled = true
////            }
//        } catch {
//            fatalError("Can't save map: \(error.localizedDescription)")
//        }
//    }
    
    sceneView.session.getCurrentWorldMap { (worldMap, error) in
        guard let worldMap = worldMap else {
            print("Can't get current world map")
//            self.setUpLabelsAndButtons(text: "Can't get current world map", canShowSaveButton: false)
//            self.showAlert(message: error!.localizedDescription)
            return
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
            UseServer.POSTRequest(StringToSend: data)
            try data.write(to: mapSaveURL, options: [.atomic])
            print(mapSaveURL)
            print(worldMap)
            print("Map Saved")
//            self.showAlert(message: "Map Saved")
        } catch {
            fatalError("Can't save map: \(error.localizedDescription)")
        }
    }
}

var mapDataFromFile: Data? {
    return try? Data(contentsOf: mapSaveURL)
}
var isRelocalizingMap = false
var virtualObjectAnchor: ARAnchor?
let virtualObjectAnchorName = "virtualObject"
func loadExperience(sceneView: ARView) {
    
//    /// - Tag: ReadWorldMap
    let worldMap: ARWorldMap = {
        guard let data = mapDataFromFile
            else { fatalError("Map data should already be verified to exist before Load button is enabled.") }
//        let data = UseServer.GETRequest.data(using: .utf8)
        UseServer.GETRequest()

        do {
            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
                else { fatalError("No ARWorldMap in archive.") }
            return worldMap
        } catch {
            fatalError("Can't unarchive ARWorldMap from file data: \(error)")
        }
    }()
//
//
//    if let snapshotData = worldMap.snapshotAnchor?.imageData,
//        let snapshot = UIImage(data: snapshotData) {
//        print("Nice")
////        snapshotThumbnail.image = snapshot
//    } else {
//        print("No snapshot image in world map")
//    }
//    // Remove the snapshot anchor from the world map since we do not need it in the scene.
////    worldMap.anchors.removeAll(where: { $0 is SnapshotAnchor })
////    worldMap.anchors.append(virtualObjectAnchor!)
    let configuration = ARWorldTrackingConfiguration()// this app's standard world tracking settings
    configuration.initialWorldMap = worldMap
    print(worldMap)
    
//    let boxAnchor = try! Experience.loadDrone()
   
    sceneView.session.run(configuration)
//    sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
  
////    configuration.initialWorldMap?.anchors.append()
//    sceneView.session.run(configuration)
////    sceneView.scene.anchors.append(virtualObjectAnchor)
//
//    isRelocalizingMap = true
//    virtualObjectAnchor = nil
//    print("now you must to see something")
    
    
    
//    guard let mapData = try? Data(contentsOf: worldMapURL), let worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: mapData) else {
//               fatalError("No ARWorldMap in archive.")
//           }
//
//           let configuration = ARWorldTrackingConfiguration()
//           configuration.planeDetection = [.horizontal]
//
//           let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
////           if let worldMap = worldMap {
//               configuration.initialWorldMap = worldMap
////               showAlert(message: "Map Loaded")
//               print("Map Loaded")
////           } else {
////               print("Map didnt Load")
//////               setUpLabelsAndButtons(text: "Move the camera around to detect surfaces", canShowSaveButton: false)
////           }
//           sceneView.debugOptions = [.showFeaturePoints]
//           sceneView.session.run(configuration, options: options)
//
}
////Отрисовка полученного объекта
//func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//    guard anchor.name == virtualObjectAnchorName
//        else { return }
//
//    // save the reference to the virtual object anchor when the anchor is added from relocalizing
//    if virtualObjectAnchor == nil {
//        virtualObjectAnchor = anchor
//    }
//    node.addChildNode(virtualObject)
//    print("Some was rendered")
//}
//Получение объекта по ссылке
//var virtualObject: SCNNode = {
//    guard let sceneURL = Bundle.main.url(forResource: "drone", withExtension: "scn", subdirectory: "Assets.scnassets/drone"),
//        let referenceNode = SCNReferenceNode(url: sceneURL) else {
//            fatalError("can't load virtual object")
//    }
//    referenceNode.load()
//
//    return referenceNode
//}()
extension ARWorldMap {
    var snapshotAnchor: SnapshotAnchor? {
        return anchors.compactMap { $0 as? SnapshotAnchor }.first
    }
}
var defaultConfiguration: ARWorldTrackingConfiguration {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    configuration.environmentTexturing = .automatic
    return configuration
}
