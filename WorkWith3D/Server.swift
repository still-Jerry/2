//
//  Server.swift
//  WorkWith3D
//
//  Created by Anatolich Mixaill on 18.07.2022.
//

import Foundation
class WorkWithServer{
    
    @Published var req1: String = "sd"
    
    static var  req="some text"
    
    func GETRequest() -> String {
        let url = URL(string: "http://192.168.0.150:3000/users/test")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            WorkWithServer.req = String(data: data, encoding: .utf8)!
//            req1=convertToDictionary(text: req)!
            print(String(data: data, encoding: .utf8)!)
            self.req1=WorkWithServer.req
            print(self.req1)
        }
        task.resume()
        return WorkWithServer.req
    }
   
    func POSTRequest(StringToSend: Data){
        let url = URL(string: "http://192.168.0.150:3000/users/test")!
        var request:NSMutableURLRequest = NSMutableURLRequest(url:url)
        request.httpMethod = "POST"
        
//        request.httpBody = StringToSend.data(using: .utf8)
        request.httpBody = StringToSend
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
            guard let data = data else {
                return
                
            }
            print(String(data: data, encoding: .utf8)!)
            print(request.httpBody)
        }
        
        print(request)
    }

}
