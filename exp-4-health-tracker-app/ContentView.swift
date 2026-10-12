//
//  ContentView.swift
//  exp-4-health-tracker-app
//
//  Created by Yashraj Ola on 12/10/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var healthModel = HealthModel()
    
    var body: some View {
        MainTabView(healthModel: healthModel)
            .environmentObject(healthModel)
    }
}

#Preview {
    ContentView()
}
