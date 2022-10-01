//
//  Model.swift
//  OsmAndTest
//
//  Created by Hasan Hasanov on 28.09.22.
//

import Foundation
// MARK: - WelcomeElement
struct Country: Codable {
    let type, name, translate: String
    let innerDownloadSuffix: String?
    let boundary: Boundary
    let polyExtract: String?
    let region: [Region]?
    let roads, wiki: Boundary?

    enum CodingKeys: String, CodingKey {
        case type, name, translate
        case innerDownloadSuffix = "inner_download_suffix"
        case boundary
        case polyExtract = "poly_extract"
        case region, roads, wiki
    }
}

enum Boundary: String, Codable {
    case no = "no"
    case yes = "yes"
}

// MARK: - WelcomeRegion
struct Region: Codable {
    let name, lang: String
    let polyExtract: PolyExtract?
    let innerDownloadPrefix: InnerDownloadPrefix?
    let joinMapFiles: Boundary?
    let region: [PurpleRegion]?
    let translate: String?
    let srtm, map, roads, hillshade: Boundary?
    let leftHandNavigation, joinRoadFiles, boundary: Boundary?
    let metric: String?

    enum CodingKeys: String, CodingKey {
        case name, lang
        case polyExtract = "poly_extract"
        case innerDownloadPrefix = "inner_download_prefix"
        case joinMapFiles = "join_map_files"
        case region, translate, srtm, map, roads, hillshade
        case leftHandNavigation = "left_hand_navigation"
        case joinRoadFiles = "join_road_files"
        case boundary, metric
    }
}

enum InnerDownloadPrefix: String, Codable {
    case name = "$name"
}

enum PolyExtract: String, Codable {
    case eastEurope = "east-europe"
    case france = "france"
    case germany = "germany"
    case northEurope = "north-europe"
    case southEurope = "south-europe"
    case westEurope = "west-europe"
}

// MARK: - PurpleRegion
struct PurpleRegion: Codable {
    let type: FluffyType?
    let name: String
    let translate: String?
    let map, srtm, hillshade, wiki: Boundary?
    let region: [FluffyRegion]?
    let boundary, innerDownloadPrefix: String?
    let joinMapFiles: Boundary?
    let polyExtract: PolyExtract?

    enum CodingKeys: String, CodingKey {
        case type, name, translate, map, srtm, hillshade, wiki, region, boundary
        case innerDownloadPrefix = "inner_download_prefix"
        case joinMapFiles = "join_map_files"
        case polyExtract = "poly_extract"
    }
}

// MARK: - FluffyRegion
struct FluffyRegion: Codable {
    let type: PurpleType?
    let name: String
    let translate, boundary: String?
    let srtm, hillshade: Boundary?
    let region: [TentacledRegion]?
}

// MARK: - TentacledRegion
struct TentacledRegion: Codable {
    let name: String
    let map: Boundary
    let translate: String?
    let hillshade: Boundary?
}

enum PurpleType: String, Codable {
    case map = "map"
    case srtm = "srtm"
}

enum FluffyType: String, Codable {
    case hillshade = "hillshade"
    case map = "map"
}

typealias Countries = [Country]
