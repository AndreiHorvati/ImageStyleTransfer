//
//  MainTabMenu.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 19.04.2023.
//

import SwiftUI

struct MainTabMenu: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            PaintingsMenu()
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Image(systemName: "paintpalette.fill")
                    Text(Strings.paintingMenuTabTitle)
                }
                .tag(0)
            
            NavigationView {
                GalleryView()
                    .toolbarBackground(.visible, for: .tabBar)
                    .navigationTitle(Strings.galleryTabTile)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "photo.fill")
                Text(Strings.galleryTabTile)
            }
            .tag(1)
            
            NavigationView {
                AccountView()
                    .navigationTitle(Strings.accountTabTitle)
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text(Strings.accountTabTitle)
            }
            .tag(2)
        }
        .navigationBarBackButtonHidden(true)
    }
}
