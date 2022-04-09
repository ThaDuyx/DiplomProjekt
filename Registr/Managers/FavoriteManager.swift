//
//  FavoriteManager.swift
//  Registr
//
//  Created by Simon Andersen on 09/04/2022.
//

import Foundation

class FavoriteManager: ObservableObject {
    @Published var favorites: [String] = []
    
    init() {
        fetchFavorites()
    }
    
    func fetchFavorites() {
        favorites = DefaultsManager.shared.favorites
    }
    
    func favoriteAction(favorite: String) {
        if favorites.contains(favorite) {
            if let index = favorites.firstIndex(of: favorite) {
                favorites.remove(at: index)
                DefaultsManager.shared.favorites = favorites
            }
        } else {
            // Updating the published variable to call a redraw of the view
            favorites.append(favorite)
            
            // Updating and saving the DefaultsManager so next time we login we have the favorites stored
            DefaultsManager.shared.favorites = favorites
        }
        
        print(DefaultsManager.shared.favorites)
    }
}
