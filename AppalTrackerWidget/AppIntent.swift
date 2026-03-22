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
        BusEntity(id: "Blue", name: "Blue"),
        BusEntity(id: "Express", name: "Express"),
        BusEntity(id: "Gold", name: "Gold"),
        BusEntity(id: "Green", name: "Green"),
        BusEntity(id: "Maroon", name: "Maroon"),
        BusEntity(id: "Orange", name: "Orange"),
        BusEntity(id: "Pink", name: "Pink"),
        BusEntity(id: "Pop105", name: "Pop 105"),
        BusEntity(id: "Purple", name: "Purple"),
        BusEntity(id: "Red", name: "Red"),
        BusEntity(id: "Silver", name: "Silver"),
        BusEntity(id: "Gray", name: "Gray"),
        BusEntity(id: "Teal", name: "Teal"),
        BusEntity(id: "Wellnedd District", name: "Wellness District"),
        BusEntity(id: "State Farm Lot Shuttle", name: "State Farm Lot Shuttle"),
        BusEntity(id: "Night Owl Express", name: "Night Owl Express"),
        BusEntity(id: "Night Owl Gold", name: "Night Owl Gold"),
        BusEntity(id: "Night Owl Pop 105", name: "Night Owl Pop 105"),
        BusEntity(id: "Night Owl Orange", name: "Night Owl Orange")
    ]
}

struct BusQuery: EntityQuery{
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

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "AppalTrack" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "Bus")
    var selectedBus: BusEntity

}

