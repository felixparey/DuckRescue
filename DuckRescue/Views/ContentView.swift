//
//  ContentView.swift
//  DuckRescue
//
//  Created by Felix Parey on 13/02/24.
//

import SwiftUI

struct ContentView: View {
    let gridItems = ["star.fill", "heart.fill", "house.fill", "car.fill", "leaf.fill", "person.fill", "flame.fill", "cloud.fill", "moon.fill", "sun.max.fill"]

    // State for the 3x3 grid items
    @State private var smallGridItems: [String?] = Array(repeating: nil, count: 9)
    let gridSize = CGFloat(60)
    let gridSpacing = CGFloat(10)
    let columns = 3

    var body: some View {
        VStack {
            // 3x3 Grid Display
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(gridSize), spacing: gridSpacing), count: columns), spacing: gridSpacing) {
                ForEach(0..<9, id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .foregroundColor(index < smallGridItems.count && smallGridItems[index] != nil ? .blue : .gray.opacity(0.2))
                            .frame(width: gridSize, height: gridSize)
                            .cornerRadius(10)

                        if let itemName = smallGridItems[index] {
                            Image(systemName: itemName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: gridSize * 0.8, height: gridSize * 0.8)
                                .foregroundColor(.white)
                                .onDrag {
                                    // Set the item being dragged, and remove it from the grid
                                    let dragItem = NSItemProvider(object: String(itemName) as NSString)
                                    DispatchQueue.main.async {
                                        smallGridItems[index] = nil // Free the space in the grid
                                    }
                                    return dragItem
                                }
                        }
                    }
                    .onDrop(of: [.text], delegate: DropViewDelegate(smallGridItems: $smallGridItems, index: index, gridItems: gridItems))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
            .padding(.top)

            Spacer()

            // Horizontal ScrollView for 5x5 Grid Items
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
                            .onDrag {
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
    }
}

struct DropViewDelegate: DropDelegate {
    @Binding var smallGridItems: [String?]
    let index: Int
    let gridItems: [String]

    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: [.text]).first {
            item.loadObject(ofClass: NSString.self) { (droppedItem, error) in
                DispatchQueue.main.async {
                    if let droppedItemString = droppedItem as? String, gridItems.contains(droppedItemString) {
                        self.smallGridItems[index] = droppedItemString
                    }
                }
            }
            return true
        }
        return false
    }
}


#Preview(windowStyle: .automatic) {
    ContentView()
}
