//
//  TutorialView.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 09.05.2023.
//

import SwiftUI

struct TutorialView: View {
    
    var body: some View {
        TabView {
            ForEach(1...5, id: \.self) { index in
                VStack {
                    Image(systemName: "bell")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 20)
                    Text("Page \(index) description")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .navigationBarHidden(false)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
