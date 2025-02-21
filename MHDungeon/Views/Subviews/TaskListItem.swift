//
//  TaskItem.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/21/25.
//

import SwiftUI

struct TaskListItem: View {
    // The task on display
    var task: Task?
    
    // Features from the task that we have brought out into their own variables
    let name: String
    let points: Int
    let expirationTime: Date
    
    // Official init, this is what should be used when this view is actually being called
    init(_ task: Task) {
        self.task = task
        
        self.name = task.name
        self.points = task.points
        self.expirationTime = task.expirationTime
    }
    
    // Preview init because error handling is impossible on those
    #if DEBUG
    init(name: String, inspirationPoints: Int, expirationTime: Date) {
        self.name = name
        self.points = inspirationPoints
        self.expirationTime = expirationTime
    }
    #endif
    
    var body: some View {
        
        // Task display bar with buttons
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color.green)
            .frame(width: screenWidth * 0.9, height: 140, alignment: .bottom)
            .overlay {
                VStack{
                    // Checkmark and name
                    HStack {
                        // Checkmark button to mark the task as complete
                        Button {
                            print("\(name) checked!")
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.black)
                                .frame(width: 80, height: 80, alignment: .topLeading)
                                .overlay {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .foregroundColor(Color.white)
                                }
                        }
                        
                        Spacer(minLength: 16)
                        
                        Text(name)
                            .font(.title2)
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                    
                    // Points and
                    HStack {
                        // TODO: Calculate the total space the points text is taking up so that it remains consistent no matter how many points are being rewarded
                        Text("\(points)")
                        Spacer(minLength: 8)
                        Text("Expires on \(expirationTime)")
                    }
                    
                }.padding()
            }
            .listRowBackground(Color.clear)
    }
}

#Preview("Task Item") {
    TaskListItem(name: "Example Task goes here. Can you not see it? Clearly, something else is going on here", inspirationPoints: 10, expirationTime: Date.now.addingTimeInterval(5 * 60))
}

// Note from Dehrens on previewing throwing objects:
//  Make a DEBUG build only fileinternal init that takes a mock-object instead that can't throw
