//
//  PlaceholderView.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 14.05.2023.
//

import SwiftUI

struct PlaceholderView: View {
    
    @State var text: String
    
    var body: some View {
        VStack {
            Image("highlighter-bw-256")
            Text(text)
                .font(.callout)
                .foregroundColor(.secondaryLabel)
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView(text: "Some text")
    }
}
