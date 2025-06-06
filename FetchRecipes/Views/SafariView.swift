//
//  SafariView.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/2/25.
//

import SwiftUI
import SafariServices

struct SFSafariView: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false
        
        let safariVC = SFSafariViewController(url: url, configuration: configuration)
        safariVC.preferredBarTintColor = nil
        safariVC.preferredControlTintColor = .orange
        safariVC.dismissButtonStyle = .done
        
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}
