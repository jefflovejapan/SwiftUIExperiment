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
}

struct ContentView : View {
    enum Constant {
        static let publicKey = "e21d74679066ca01db8fe17607526ede"
        static let privateKey = "25f8d0f87c3e9aaae1870268c2fb2039ee739b13"
    }

    @State private var heroes: [Hero] = []
    var body: some View {
        List(heroes) { hero in
            Text(hero.name)
            }
            .onAppear {
                self.fetch()
        }
    }

    func fetch() {
        var urlComponents = URLComponents(string: "https://gateway.marvel.com/v1/public/characters")!
        let timeStr = String(Date().timeIntervalSince1970)
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: Constant.publicKey),
            URLQueryItem(name: "ts", value: timeStr),
            URLQueryItem(name: "hash", value: (timeStr + Constant.privateKey + Constant.publicKey).md5)
        ]
        let request = URLRequest(url: urlComponents.url!)
        URLSession.shared.dataTask(with: request) { (maybeData, maybeResponse, maybeError) in
            guard let data = maybeData else {
                return
            }
            do {
                let heroesResponse = try JSONDecoder().decode(HeroesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.heroes = heroesResponse.data.results
                }
            } catch {
                let responseStr = String(data: data, encoding: .utf8)
                print(responseStr as Optional)
            }
            }
            .resume()
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
