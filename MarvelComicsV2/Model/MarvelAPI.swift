//
//  MarvelAPI.swift
//  MarvelComicsV2
//
//  Created by Norah Almaneea on 18/05/2021.
//

import Foundation
import Alamofire
import SwiftHash

class MarvelAPI {

    static private let basePath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "be35636ff73814e6b4a58034fd5421438ccc35c7"
    static private let publicKey = "8b5eba3f5fa739352b21d956170df07b"
    static private let limit = 50

    class func loadHeroes(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void) {
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))"
        } else {
            startsWith = ""
        }

        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print(url)
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data,
                let marvelInfo = try? JSONDecoder().decode(MarvelInfo.self, from: data),
                marvelInfo.code == 200 else {
                    onComplete(nil)
                    return
            }
            onComplete(marvelInfo)
        }
    }

    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }

}

