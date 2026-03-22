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
        HStack (spacing: 30) {
            VStack {
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
                        stop in Text("\(stop.name) · ").font(.footnote)
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

