//
//  MoreView.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 16/11/23.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                ForEach(1..<11){
                    Text("This is number: \($0)")
                        .font(.title)
                        .padding(2)
                }
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) { // Use ScrollView for horizontal arrangement
                    HStack {
                        ForEach(1..<6) {
                            Image(systemName: "\($0).circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("More View")
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}

struct MoreViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UIHostingController(rootView: MoreView())
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
}
