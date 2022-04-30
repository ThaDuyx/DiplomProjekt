//
//  FavoriteManager.swift
//  Registr
//
//  Created by Simon Andersen on 09/04/2022.
//

import Foundation

class FavoriteManager: ObservableObject {
    @Published var favorites: [String] = []
    @Published var newFavorite = String()
    @Published var deselectedFavorite = String()
    
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
                deselectedFavorite = favorite
            }
        } else {
            // Updating the published variable to call a redraw of the view
            favorites.append(favorite)
            newFavorite = favorite
            
            
            // Updating and saving the DefaultsManager so next time we login we have the favorites stored
            DefaultsManager.shared.favorites = favorites
        }
        favorites.sort{ $0 < $1 }
        
    }
}
