//
//  AppalTrackerWidget.swift
//  AppalTrackerWidget
//
//  Created by Eric Hendershot on 3/21/26.
//

import WidgetKit
import SwiftUI
let test = routeData()

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), timeTable: [:])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, timeTable: [:])
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let bus = configuration.selectedBus?.name
        let stops = configuration.selectedStops ?? []
        var times: [nextStopInfo] = []
        var timeTable: [String: String] = [:]
        
        for stop in stops {
            do {
                times = try await test.getFilteredDataByName(nameValue: stop.name)
                for i in times {
                    if i.routeID == bus {
                        timeTable[stop.name] = i.time
                    }
                }
            } catch {
                print("error fetching")
            }
        }
        
        
        let entry = SimpleEntry(date: Date(), configuration: configuration, timeTable: [:])
        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let timeTable: [String: String]
}

struct AppalTrackerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        if widgetFamily == .accessoryInline {
            Text("\(entry.configuration.selectedBus?.name ?? "N/A") \(entry.configuration.selectedStops?.first?.name ?? "N/A") · ")
        }
        else {
            HStack(spacing: 30) {
                VStack(alignment: .leading) {
                    Text("Bus:")
                        .font(.footnote)
                    Text(entry.configuration.selectedBus?.name ?? "N/A")
                        .font(.headline)
                }
                VStack(alignment: .trailing, spacing: 4) {
                    if (entry.configuration.selectedStops ?? []).isEmpty {
                        Text("N/A").font(.subheadline)
                    } else {
                        ForEach(entry.configuration.selectedStops ?? [], id: \.id ) {
                            stop in Text("\(stop.name) · \(entry.timeTable[stop.name] ?? "NA")").font(.footnote)
                        }
                    }
                }
            }
        }
    }
}

struct AppalTrackerWidget: Widget {
    let kind: String = "AppalTrackerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            AppalTrackerWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("AppalTrack")
        .description("Track a bus and your favorite stops!.")
        .supportedFamilies([.systemMedium, .accessoryInline])
    }
}

