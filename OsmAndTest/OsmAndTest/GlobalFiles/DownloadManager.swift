//
//  DownloadManager.swift
//  OsmAndTest
//
//  Created by Hasan Hasanov on 29.09.22.
//

import Foundation

protocol UpdateProgress{
    func didUpdateProgrress(progress: [String: Float])
}

class DownloadManager: NSObject{
    
    static let shared = DownloadManager()
    
    
    var delegate: UpdateProgress?
    
    private var savedMapsURL = Set<String>()
    
    private var queue: [String] = []
    
    var progress: [String: Float] = [:]
    
    
    func submitToQueue(id: String){
        progress[id] = 0.0
        if !queue.contains(id) && !savedMapsURL.contains(id){
            queue.append(id)
            if queue.count == 1{
                let url = generateUrlString(with: queue.first!)
                downloadMap(urlString: url)
            }
        }
    }
    
    func generateSpecificID(name: String, regionName: String = "", suffix: String) -> String{
        if regionName == ""{
            return "\(name.capitalizingFirstLetter())_\(suffix)"
        }else{
            return "\(name.capitalizingFirstLetter())_\(regionName)_\(suffix)"
        }
        
    }
    
    private func generateUrlString(with id: String) -> String {
        let urlString = "https://download.osmand.net/download.php?standard=yes&file=\(id)_2.obf.zip"
        return urlString
    }
    
    private func downloadMap(urlString: String){
        let url = URL(string: urlString)!
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        let session = URLSession.shared.downloadTask(with: req)
        
        session.delegate = self
        
        session.resume()
    }
}
extension DownloadManager: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        savedMapsURL.insert(queue.first!)
        queue.removeFirst()
        if queue.count != 0{
            let urlString = generateUrlString(with: queue.first!)
            downloadMap(urlString: urlString)
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress =  Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        self.progress[queue.first!] = progress
        delegate?.didUpdateProgrress(progress: self.progress)
        print("Progress \(progress)")
    }
    
}
