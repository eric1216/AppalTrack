//
//  AppIntent.swift
//  AppalTrackerWidget
//
//  Created by Eric Hendershot on 3/21/26.
//

import WidgetKit
import AppIntents


struct BusEntity: AppEntity {
    var id: String
    var name: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Bus"
    static var defaultQuery = BusQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static let allBusses: [BusEntity] = [
        BusEntity(id: "blue", name: "Blue"),
        BusEntity(id: "express", name: "Express"),
        BusEntity(id: "gold", name: "Gold"),
        BusEntity(id: "green", name: "Green"),
        BusEntity(id: "maroon", name: "Maroon"),
        BusEntity(id: "orange", name: "Orange"),
        BusEntity(id: "pink", name: "Pink"),
        BusEntity(id: "pop105", name: "Pop 105"),
        BusEntity(id: "purple", name: "Purple"),
        BusEntity(id: "red", name: "Red"),
        BusEntity(id: "silver", name: "Silver"),
        BusEntity(id: "gray", name: "Gray"),
        BusEntity(id: "teal", name: "Teal"),
        BusEntity(id: "wellnessDistrict", name: "Wellness District"),
        BusEntity(id: "stateFarmLotShuttle", name: "State Farm Lot Shuttle"),
        BusEntity(id: "sightOwlExpress", name: "Night Owl Express"),
        BusEntity(id: "nightOwlGold", name: "Night Owl Gold"),
        BusEntity(id: "nightOwlPop 105", name: "Night Owl Pop 105"),
        BusEntity(id: "nightOwlOrange", name: "Night Owl Orange")
    ]
}

struct StopEntity: AppEntity {
    var id: String
    var name: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Stop"
    static var defaultQuery = StopQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static let specificStops: [StopEntity] = [
        StopEntity(id: "asuPeacockTrafficCircle", name: "ASU Peacock Traffic Circle"),
        StopEntity(id: "asuSrc", name: "ASU SRC"),
        StopEntity(id: "asuLivingLearningCenterUp", name: "ASU Living Learning Center (Up)"),
        StopEntity(id: "asuMountaineerHall", name: "ASU Mountaineer Hall"),
        StopEntity(id: "asuAppalachianHeights", name: "ASU Appalachian Heights"),
        StopEntity(id: "topOfBodenheimerUp", name: "Top of Bodenheimer (up)"),
        StopEntity(id: "southLotBaseballStadium", name: "South Lot / Baseball Stadium"),
        StopEntity(id: "topOfBodenheimerDown", name: "Top of Bodenheimer (down)"),
        StopEntity(id: "greenwoodLot", name: "Greenwood Lot"),
        StopEntity(id: "asuLivingLearningCenterDown", name: "ASU Living Learning Center (down)"),
        StopEntity(id: "asuWalkerHallBodenheimerDrive", name: "ASU Walker Hall / Bodenheimer Drive"),
        StopEntity(id: "asuCollegeStStation", name: "ASU College St Station"),
        StopEntity(id: "howardStHardinSt", name: "Howard St / Hardin St"),
        StopEntity(id: "asuDogwoodHall", name: "ASU Dogwood Hall"),
        StopEntity(id: "asuSkywalk", name: "ASU Skywalk"),
        StopEntity(id: "asuTrivetteHall", name: "ASU Trivette Hall"),
        StopEntity(id: "asuPeacockTrafficLight", name: "ASU Peacock Traffic Light"),
        StopEntity(id: "waterStKingSt", name: "Water St / King St"),
        StopEntity(id: "kingStDepotSt", name: "King St / Depot St")
    ]
}

struct BusQuery: EntityQuery {
    func entities(for identifiers: [BusEntity.ID]) async throws -> [BusEntity] {
        BusEntity.allBusses.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [BusEntity] {
        BusEntity.allBusses
    }
    
    func defaultResult() async -> BusEntity? {
        BusEntity.allBusses.first
    }
}

struct StopQuery: EntityQuery {
    func entities(for identifiers: [StopEntity.ID]) async throws -> [StopEntity] {
        StopEntity.specificStops.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [StopEntity] {
        StopEntity.specificStops
    }
    
    func defaultResult() async -> StopEntity? {
        StopEntity.specificStops.first
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "AppalTrack" }
    static var description: IntentDescription { "This is an example widget." }

    @Parameter(title: "Bus")
    var selectedBus: BusEntity?

    @Parameter(title: "Stops (max. 3)", size: .init(min: 0, max: 3))
    var selectedStops: [StopEntity]?
}

