//
//  ContentView.swift
//  TelegramDarkModeAnimationChallenge
//
//  Created by Ramill Ibragimov on 9/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: Int = 0
    /// Sample Toggle States
    @State private var toggle: [Bool] = Array(repeating: false, count: 10)
    /// Interface Style
    @AppStorage("toggleDarkMode") private var toggleDarkMode: Bool = false
    @AppStorage("activateDarkMode") private var activateDarkMode: Bool = false
    @State private var buttonRec: CGRect = .zero
    /// Current & Previous State Images
    @State private var currentImage: UIImage?
    @State private var previousImage: UIImage?
    @State private var maskAnimation: Bool = false
    
    var body: some View {
        /// Sample View
        TabView(selection: $activeTab) {
            NavigationStack {
                List {
                    Section("Text Section") {
                        Toggle("Large Display", isOn: $toggle[0])
                        Toggle("Bold Text", isOn: $toggle[1])
                    }
                    
                    Section {
                        Toggle("Night Light", isOn: $toggle[2])
                        Toggle("True Tone", isOn: $toggle[3])
                    } header: {
                        Text("Display Section")
                    } footer: {
                        Text("This is a Sample Footer.")
                    }
                }
                .navigationTitle("Dark Mode")
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                toggleDarkMode.toggle()
            }, label: {
                Image(systemName: toggleDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.title2)
                    .foregroundStyle(Color.primary)
                    .symbolEffect(.bounce, value: toggleDarkMode)
                    .frame(width: 40, height: 40)
            })
            .rect { rect in
                buttonRec = rect
            }
            .padding(10)
            .disabled(currentImage != nil || previousImage != nil || maskAnimation)
        }
        .createImages(toggleDarkMode: toggleDarkMode,
                      currentImage: $currentImage,
                      previousImage: $previousImage,
                      activateDarkMode: $activateDarkMode
        )
        .overlay(content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                if let previousImage, let currentImage {
                    ZStack {
                        Image(uiImage: previousImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                        
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                            .mask(alignment: .topLeading) {
                                Circle()
                                    .frame(width: buttonRec.width * (maskAnimation ? 80 : 1), height: buttonRec.height * (maskAnimation ? 80 : 1), alignment: .bottomLeading)
                                    .frame(width: buttonRec.width, height: buttonRec.height)
                                    .offset(x: buttonRec.minX, y: buttonRec.minY)
                                    .ignoresSafeArea()
                            }
                    }
                    .task {
                        guard !maskAnimation else { return }
                        withAnimation(.easeInOut(duration: 0.9), completionCriteria: .logicallyComplete) {
                            maskAnimation = true
                        } completion: {
                            /// Remove all snapshots
                            self.currentImage = nil
                            self.previousImage = nil
                            maskAnimation = false
                        }
                    }
                }
            })
            /// Reverse Masking
            .mask({
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .frame(width: buttonRec.width, height: buttonRec.height)
                            .offset(x: buttonRec.minX, y: buttonRec.minY)
                            .blendMode(.destinationOut)
                    }
            })
            .ignoresSafeArea()
        })
        .preferredColorScheme(activateDarkMode ? .dark : .light)
    }
    
    
}

#Preview {
    ContentView()
}
