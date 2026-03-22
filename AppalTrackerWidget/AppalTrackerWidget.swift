//
//  AppalTrackerWidget.swift
//  AppalTrackerWidget
//
//  Created by Eric Hendershot on 3/21/26.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct AppalTrackerWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack (spacing: 35) {
            VStack {
                Text("Bus:")
                    .font(.caption)
                Text(entry.configuration.selectedBus?.name ?? "N/A")
                    .font(.headline)
            }
            Text("Hello")
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

func getSelectedBus() -> StopEntity {
    var entry: Provider.Entry
    return StopEntity(id: "se", name: entry.configuration.selectedBus?.name ?? "N/A")
}
