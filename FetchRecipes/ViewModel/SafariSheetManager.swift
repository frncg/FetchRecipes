//
//  SafariSheetManager.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/6/25.
//

import SwiftUI

@Observable
class SafariSheetManager {
    
    private(set) var safariSheetURL: IdentifiableURL?
    
    func present(_ url: URL) {
        safariSheetURL = IdentifiableURL(url)
    }

    func dismiss() {
        safariSheetURL = nil
    }
}
