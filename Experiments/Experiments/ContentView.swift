//
//  ContentView.swift
//  Experiments
//
//  Created by Jeffrey Blagdon on 2019-08-07.
//  Copyright © 2019 mostafaandjeff. All rights reserved.
//

import SwiftUI

struct HeroesResponse: Codable {
    var data: ResponseData
}

struct ResponseData: Codable {
    var results: [Hero]
}

struct Hero: Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var thumbnail: HeroThumbnail
}

struct HeroThumbnail: Codable {
    var path: String
    var `extension`: String
}

extension HeroThumbnail {
    var imageURL: URL? {
        let str = [self.path, self.extension].joined(separator: ".")
        return URL(string: str)
    }
}

struct HeroView: View {
    @State var hero: Hero
    @State var image: UIImage?

    var body: some View {
        HStack {
            image.map {
                Image(uiImage: $0)
                    .resizable()
                .frame(width: 50, height: 50, alignment: .leading)
            }
            VStack(alignment: .leading) {
                Text(hero.name)
                Text(hero.description)
            }
                .onAppear {
                    fetchThumbnail(url: self.hero.thumbnail.imageURL, binding: self.$image)
            }
        }
    }
}

struct ContentView : View {
    @State private var heroes: [Hero] = []
    var body: some View {
        List(heroes) { hero in
            HeroView(hero: hero)
            }.onAppear{
                fetchHeroes(binding: self.$heroes)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
