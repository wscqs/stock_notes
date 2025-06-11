//
//  MBALibWidget.swift
//  MBALibWidget
//
//  Created by 1 on 2023/3/20.
//  Copyright © 2023 mbalib. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct MBALibWidgetEntryView : View {
    var entry: Provider.Entry
    @State var text: String = ""
    var blackColor: Color = Color(red: 0.19, green: 0.19, blue: 0.2)
    var prefixUrl:String = "stocknote://stocknote.com/#/"
//    var prefixUrl:String = "http://passport.test.mbalib.com/appopen?arguments="
    
    var body: some View {
        GeometryReader { geo in
            
            VStack(alignment:.center,spacing: 18){
                
                Link(destination: URL(string: self.prefixUrl+"tabs?tab=stock&op=search")!) {
                    HStack{
                        Image("zj_img_logo").padding(.leading,16)
                        Text("搜索").font(.system(size: 15,weight: .bold))
                        Spacer()
                    }.frame(width: geo.size.width-16*2,height: 48)
                        .foregroundColor(blackColor)
                        .background(Color(hex: "F5F7FA"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color(hex: "EDEFF2"), lineWidth: 2)
                        )
                }

                HStack(alignment:.center,spacing: 0){
                    
                    Link(destination: URL(string: self.prefixUrl+"tabs?tab=stock&op=saying")!) {
                        TImageBTitleView(title: "名言警句",backgroundColor: .red)
                            .frame(width: (geo.size.width-16*2)/5)
                    }
                    Link(destination: URL(string: self.prefixUrl+"tabs?tab=stock&op=meetbs")!) {
                        TImageBTitleView(imageString: "zj_ic_wd", title: "满足买卖",backgroundColor: .blue)
                            .frame(width: (geo.size.width-16*2)/5)
                    }
                    Link(destination: URL(string: self.prefixUrl+"tabs?tab=stock&op=nearbs")!) {
                        TImageBTitleView(imageString: "zj_ic_kt", title: "临近买卖",backgroundColor: .orange)
                            .frame(width: (geo.size.width-16*2)/5)
                    }
                    Link(destination: URL(string: self.prefixUrl+"stockedit")!) {
                        TImageBTitleView(imageString: "zj_ic_dkj", title: "新建股票",backgroundColor: .yellow)
                            .frame(width: (geo.size.width-16*2)/5)
                    }
                    Link(destination: URL(string: self.prefixUrl+"noteedit")!) {
                        TImageBTitleView(imageString: "zj_ic_mba", title: "新建笔记",backgroundColor: .pink)
                            .frame(width: (geo.size.width-16*2)/5)
                    }
                }
            }
            .padding()
        }
    }
}

struct MBALibWidget: Widget {
    let kind: String = "StockNotesWight"

    var body: some WidgetConfiguration {
        let config = StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOSApplicationExtension 17.0, *) {
                MBALibWidgetEntryView(entry: entry).containerBackground(for: .widget) {
                    Color.clear
                }
            } else {
                MBALibWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("股票笔记")
        .description("股票笔记小组件")
        .supportedFamilies([.systemMedium])//.systemSmall,
        
        if #available(iOSApplicationExtension 15.0, *) {
            return config.contentMarginsDisabled()
        }
        return config
    }
}

struct MBALibWidget_Previews: PreviewProvider {
    static var previews: some View {
        MBALibWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

