//
//  ContentView.swift
//  WorkWith3D
//
//  Created by Anatolich Mixaill on 15.07.2022.
//

import SwiftUI
import RealityKit


struct ContentView : View {
    @State private var ar = false
    @State private var postv = false
    @State private var getv = false
    
    @State private var UseServer=WorkWithServer()
    @State private var firstName = "DaftPunk"
    var body: some View {
        ZStack{
            ARViewContainer(ar: $ar, getv: $getv, postv: $postv).edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                HStack{
                    Button(
                        action: {
                            self.ar = true
                            self.getv = false
                            self.postv = false
//                            ARViewContainerNew().edgesIgnoringSafeArea(.all)

                        },
                        label: { Text("View").font(.system(size: 30, weight: .bold)) }
                    )
                    Spacer()
                    Button(
                        action: {
                            self.getv = true
                            self.ar = false
                            self.postv = false
//                            print(UseServer.GETRequest())
//                            print("successful get request")
                            
                        },
                        label: { Text("Get").font(.system(size: 30, weight: .bold)) }
                    )
                    Spacer()
                    Button(
                        action: {
                            self.getv = false
                            self.ar = false
                            self.postv = true
//                            UseServer.POSTRequest(StringToSend: firstName)
//                            print("successful post request")
                            
//                            switch frame.worldMappingStatus {
//                            case .extending, .mapped:
//                                saveExperienceButton.isEnabled =
//                                    virtualObjectAnchor != nil && frame.anchors.contains(virtualObjectAnchor!)
//                            default:
//                                saveExperienceButton.isEnabled = false
//                            }
//                            statusLabel.text = """
//                            Mapping: \(frame.worldMappingStatus.description)
//                            Tracking: \(frame.camera.trackingState.description)
//                            """
//                            updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
                        },
                        label: { Text("Post").font(.system(size: 30, weight: .bold)) }
                    )
                }
            }
        }
    }
}



struct ARViewContainer: UIViewRepresentable {
    @Binding var ar: Bool
    @Binding var getv: Bool
    @Binding var postv: Bool
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        // Load the "Box" scene from the "Experience" Reality File
//        addSome(arView: arView)
        return arView
        
    }
   
    func updateUIView(_ uiView: ARView, context: Context) {
        if ar{
            let boxAnchor = try! Experience.loadDrone()
            uiView.scene.anchors.append(boxAnchor)
            print("view is done")

        }
        if postv{
            saveExperience(sceneView: uiView)
            
            print("post is done")
//            uiView.scene.anchors.removeAll()
        }
        if getv{
            loadExperience(sceneView: uiView)
            
            print("get is done")

        }
 
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
