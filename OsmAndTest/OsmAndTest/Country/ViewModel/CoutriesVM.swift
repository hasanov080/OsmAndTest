//
//  ViewModel.swift
//  OsmAndTest
//
//  Created by Hasan Hasanov on 28.09.22.
//

import Foundation
import UIKit
class CoutriesVM: NSObject{
    private let xmlPath = Bundle.main.path(forResource: "JSON", ofType: "json")
    private let downloadManager = DownloadManager.shared
    
    func getJsonData(complition: @escaping ((Countries?) -> Void)){
        let data = convertXmlToData()
        let decoded = dataToStruct(data: data)
        complition(decoded)
    }
    
    func getCountriesData(complition: @escaping ((Country?) -> Void)){
        let data = convertXmlToData()
        let decoded = dataToStruct(data: data)
        let countriesData = decoded?.first(where: { element in
            return element.type == "continent"
        })
        complition(countriesData)
    }
    
    
    
    func getFilledSpaceFrac() -> Double{
        return Double(UIDevice.current.usedDiskSpaceInBytes) / Double(UIDevice.current.totalDiskSpaceInBytes)
    }
    
    
    func getIndex(countriesData: [Region], myData: Countries?, progress: [String: Float]) -> [(Int, String)]{
        var indexes = [(Int, String)]()
        progress.keys.forEach { id in
            let index = countriesData.firstIndex(where: { region in
                let suffix = myData?.first(where: { element in
                    return element.type == "continent"
                })
                let localID = self.downloadManager.generateSpecificID(name: region.name, suffix: suffix?.name ?? "-")
                return localID == id
            }) ?? -1
            if index != -1{
                indexes.append((index, id))
            }
        }
        return indexes
    }
    
    
    private func convertXmlToData() -> Data?{
        let url = URL(fileURLWithPath: xmlPath ?? "")
        let data = try! Data(contentsOf: url)
        return data
    }
    private func dataToStruct(data: Data?) -> Countries? {
        if let data{
            
            let decodedData = try! JSONDecoder().decode(Countries.self, from: data)
            return decodedData
        }else{
            return nil
        }
    }
}
