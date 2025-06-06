//
//  IdentifiableURL.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/6/25.
//

import Foundation

struct IdentifiableURL: Identifiable {
    var id: String
    var url: URL
    
    init(_ url: URL) {
        self.id = url.absoluteString
        self.url = url
    }
}
