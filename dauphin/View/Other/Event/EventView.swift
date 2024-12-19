//
//  EventView.swift
//  dauphin
//
//  Created by \u8b19 on 12/18/24.
//

import SwiftUI

struct EventView: View {
    @StateObject private var viewModel = EventViewModel()
    private let eventManager = EventManager()
    @State private var toggleState = true // Track the toggle state
    
    var body: some View {
        
        List(viewModel.events) { event in
            HStack {
                VStack(alignment: .leading) {
                    Text(event.event)
                        .font(.headline)
                    HStack() {
                        if(event.startDate == event.endDate){
                            Text("\(event.startDate, formatter: dateFormatter)")
                                .font(.footnote)
                        } else {
                            Text("\(event.startDate, formatter: dateFormatter) - \(event.endDate, formatter: dateFormatter)")
                                .font(.footnote)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    eventManager.requestAccessAndAddEvent(event: event)
                }) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }.padding(2)
        }
        .navigationTitle("行事曆")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    toggleState.toggle()
                    let queryParameters: [String: String] = toggleState ? ["t": "1"] : ["t": "2"]
                    viewModel.loadXMLData(withQuery: queryParameters)
                    viewModel.objectWillChange.send()
                    print(viewModel.events.count)
                }) {
                    HStack(spacing: 0) {
                        Text("上")
                            .font(.subheadline)
                            .frame(width: 50, height: 30)
                            .background(toggleState ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(toggleState ? .white : .blue)
                            .cornerRadius(8)
                        Text("下")
                            .font(.subheadline)
                            .frame(width: 50, height: 30)
                            .background(!toggleState ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(!toggleState ? .white : .blue)
                            .cornerRadius(8)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
                
            }
        }
        .onAppear {
            let queryParameters = [
                "t": "1"
            ]
            viewModel.loadXMLData(withQuery: queryParameters)
            print(viewModel.events.count)
        }
    }
}

private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy M d EEEㄆE"
    formatter.locale = Locale(identifier: "zh_TW")
    return formatter
}

#Preview {
    EventView()
}
