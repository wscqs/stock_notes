////
////  stocknotesWight.swift
////  stocknotesWight
////
////  Created by 陈秋松 on 2025/5/8.
////
//
//import WidgetKit
//import SwiftUI
//
//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), emoji: "😀")
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), emoji: "😀")
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, emoji: "😀")
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//
////    func relevances() async -> WidgetRelevances<Void> {
////        // Generate a list containing the contexts this widget is relevant in.
////    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let emoji: String
//}
//
//struct stocknotesWightEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//
//            Text("Emoji:")
//            Text(entry.emoji)
//        }
//    }
//}
//
//struct stocknotesWight: Widget {
//    let kind: String = "stocknotesWight"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
//                stocknotesWightEntryView(entry: entry)
//                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                stocknotesWightEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//    }
//}
//
//#Preview(as: .systemSmall) {
//    stocknotesWight()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
