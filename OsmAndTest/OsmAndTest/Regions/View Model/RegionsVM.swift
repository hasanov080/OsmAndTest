//
//  RegionsVM.swift
//  OsmAndTest
//
//  Created by Hasan Hasanov on 01.10.22.
//

import Foundation
class RegionsVM{
    private let downloadManager = DownloadManager.shared
    func getSpecificID(regions: Region?, progress: [String: Float], suffix: String) -> [(Int, String)]{
        var indexes = [(Int, String)]()
        progress.keys.forEach { id in
            let index = regions?.region?.firstIndex(where: { region in
                let localID = self.downloadManager.generateSpecificID(name: regions?.name ?? "",regionName: region.name, suffix: suffix)
                return localID == id
            })
            if let index{
                indexes.append((index, id))
            }
        }
        return indexes
    }
}
