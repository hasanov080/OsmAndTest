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
