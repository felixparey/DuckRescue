//
//  ContentView.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import SwiftUI

struct ContentView: View {
    // list of entities
    let gridItems = ["star.fill", "heart.fill", "house.fill", "car.fill", "leaf.fill", "person.fill", "flame.fill", "cloud.fill", "moon.fill", "sun.max.fill"]

    @State private var selectedItem: String? = nil
    @State private var draggedItem: String? = nil

    var body: some View {
        ZStack {
            VStack {
                //drag the thing for make it spawn
                if let draggedItem = draggedItem {
                    Image(systemName: draggedItem)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .transition(.scale)
                }

                Spacer()
            }
// Array thing + Space
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(100))], spacing: 20) {
                    ForEach(gridItems, id: \.self) { item in
                        Image(systemName: item)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .onTapGesture {
                                withAnimation {
                                    selectedItem = item
                                }
                            }
                            .onDrag {
                                self.draggedItem = item
                                return NSItemProvider(object: String(item) as NSString)
                            }
                    }
                }
                .padding(.horizontal)
                .frame(height: 120)
                .background(Color.gray.opacity(0.2))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onDrop(of: [.text], delegate: DropViewDelegate(item: $draggedItem))
    }
}

//if dragged out, spawns.
struct DropViewDelegate: DropDelegate {
    @Binding var item: String?

    func performDrop(info: DropInfo) -> Bool {
        self.item = nil
        return true
    }
}



#Preview(windowStyle: .automatic) {
    ContentView()
}
