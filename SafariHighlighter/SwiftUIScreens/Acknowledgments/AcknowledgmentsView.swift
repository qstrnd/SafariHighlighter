//
//  AcknowledgmentsView.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 12.05.2023.
//

import SwiftUI

struct AcknowledgmentsView: View {
    
    static let defaultAcknowledgements: [Acknowledgement] = [
        .init(
            name: "SnapKit",
            description: "Library for easier work with AutoLayout",
            url: URL(string: "https://github.com/SnapKit/SnapKit")!
        ),
        .init(
            name: "Icon8",
            description: "For providing some of the icons",
            url: URL(string: "https://icons8.com/")!
        )
    ]
    
    struct Acknowledgement {
        let name: String
        let description: String
        let url: URL
    }
    
    var acknowledgements: [Acknowledgement]
    
    var body: some View {
        List(acknowledgements, id: \.name) { model in
            HStack {
                VStack(alignment: .leading) {
                    Text(model.name)
                        .font(.body)
                    
                    Text(model.description)
                        .font(.caption)
                    
                }.onTapGesture {
                    UIApplication.shared.open(model.url)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.separator)
            }
        }
        .navigationBarHidden(false)
        .navigationTitle("Acknowledgements")
    }
}

struct AcknowledgmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AcknowledgmentsView(acknowledgements: AcknowledgmentsView.defaultAcknowledgements)
    }
}
