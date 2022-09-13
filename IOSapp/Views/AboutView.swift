//
//  AboutView.swift
//  IOSapp
//
//  Created by Aleš Stanislav on 09.09.2022.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section(header: Text("Author"),
                content: {
                HStack {
                    
                    Spacer()
                    Link("Aleš Stanislav", destination: URL(string: "https://mrstanda.xyz")!)
                }
            })
            Section(header: Text("Version"), content: {
                HStack {
                    Text("App version")
                    Spacer()
                    Text("1.0.0")
                }
            })
        }
        .navigationBarTitle("About App", displayMode: .inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
