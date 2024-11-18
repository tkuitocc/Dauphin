//
//  KeyConstants.swift
//  campuspass_ios
//
//  Created by \u8b19 on 11/17/24.
//

import Foundation

enum KeyConstants {
    static func loadAPIKeys() async throws {
        let request = NSBundleResourceRequest(tags: ["APIKeys"])
        do {
            try await request.beginAccessingResources()
        } catch {
            print("Error: Unable to access resources with tag 'APIKeys'. Details: \(error.localizedDescription)")
            throw error
        }

        guard let url = Bundle.main.url(forResource: "APIKEYS", withExtension: "json") else {
            print("Error: Unable to find 'APIKEYS.json' in the main bundle.")
            throw NSError(domain: "KeyConstants", code: 404, userInfo: [NSLocalizedDescriptionKey: "APIKEYS.json file not found in main bundle."])
        }

        do {
            let data = try Data(contentsOf: url)
            APIKeys.storage = try JSONDecoder().decode([String: String].self, from: data)
            print("Loaded APIKeys: \(APIKeys.storage)") // Debug print to confirm successful loading
        } catch {
            print("Error: Failed to load or decode 'APIKEYS.json'. Details: \(error.localizedDescription)")
            throw error
        }

        request.endAccessingResources()
    }

    enum APIKeys {
        static fileprivate(set) var storage = [String: String]()

        static var AES256IV: String {
            if let apiKey = storage["AES256IV"] {
                return apiKey
            } else {
                print("Warning: 'AES256IV' not found in storage. Returning default value 'NOTHING1'.")
                return "NOTHING1"
            }
        }

        static var AES256KEY: String {
            if let apiKey2 = storage["AES256KEY"] {
                return apiKey2
            } else {
                print("Warning: 'AES256KEY' not found in storage. Returning default value 'NOTHING2'.")
                return "NOTHING2"
            }
        }
    }
}
