//
//  HomeView.swift
//  Exp2
//
//  Created by KJSCE on 21/08/26.
//

import SwiftUI

struct HomeView: View{
    var body : some View{
        ZStack{
            LinearGradient(colors: [.indigo,.black,.black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack{
                Spacer()
                HStack(spacing: 2) {
                    Text("CAMPUS")
                        .font(.system(size: 28, weight: .ultraLight))
                    
                    Text("ONE")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white) // Accent color for the second word
                }
                Spacer()
                HStack{
                    NavigationLink {
                        Faculty()
                    } label: {
                        Text("Faculties")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity) // Makes both buttons in a row equal width
                            .padding(.vertical, 16)      // Increases button height
                    }
                    .buttonStyle(GlassButtonStyle())
                    NavigationLink {
                        Department()
                    } label: {
                        Text("Department")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity) // Makes both buttons in a row equal width
                            .padding(.vertical, 16)      // Increases button height
                    }
                    .buttonStyle(GlassButtonStyle())
                }
                HStack{
                    NavigationLink {
                        ContactUs()
                    } label: {
                        Text("Contact US")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity) // Makes both buttons in a row equal width
                            .padding(.vertical, 16)      // Increases button height
                    }
                    .buttonStyle(GlassButtonStyle())
                    NavigationLink {
                        Facilities()
                    } label: {
                        Text("Facilities")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity) // Makes both buttons in a row equal width
                            .padding(.vertical, 16)      // Increases button height
                    }
                    .buttonStyle(GlassButtonStyle())
                }
                Spacer()
                
            }.navigationTitle("HomeView").colorScheme(ColorScheme.dark)
        }
    }
}

#Preview {
    HomeView()
}
