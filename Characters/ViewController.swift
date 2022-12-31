//
//  ViewController.swift
//  Characters
//
//  Created by Ferhat Adiyeke on 26.12.2022.
//

import UIKit



extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class ViewController: UIViewController {
    
    var searching = false
    var searchedChar = [HeroStats]()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var collectionView: UICollectionView!
    var heroes = [HeroStats]()
    var hero:HeroStats!
    
  // var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(downlandJSON), userInfo: nil, repeats: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downlandJSON {
            self.collectionView.reloadData()
            }
        
        configureSearchController()
        
    }
    
    
    
    
   
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar  .placeholder = "Search"
        
    }
    
     func downlandJSON(completed: @escaping () -> ()) {
        let url = URL(string: "https://opendota.com/api/heroStats")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.heroes = try JSONDecoder().decode([HeroStats].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON error")
                }
            }
        }.resume()
    }
    
    
    
}


extension ViewController: UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching
        {
            return searchedChar.count
        }
        else
        {
            return heroes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell

        if searching
        {
            
            cell.label.text = searchedChar[indexPath.row].localized_name.capitalized
            cell.imageView.contentMode = .scaleAspectFill
            let defaultLink = "https://api.opendata.com"
            let completeLink = defaultLink + heroes[indexPath.row].img
            cell.imageView.downloaded(from: completeLink)
            
        }
        else
        {
          
            cell.label.text = heroes[indexPath.row].localized_name
            cell.imageView.contentMode = .scaleAspectFill
            let defaultLink = "https://api.opendata.com"
            let completeLink = defaultLink + heroes[indexPath.row].img
            cell.imageView.downloaded(from: completeLink)

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        if !searchText.isEmpty {
            
            searching = true
            searchedChar.removeAll()
            for char in heroes
            {
                if char.localized_name.lowercased().contains(searchText.lowercased()) {
                    searchedChar.append(char)
                }
            }
        }
        else
        {
            searching = false
            searchedChar.removeAll()
            searchedChar = heroes
        }
        collectionView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedChar.removeAll()
        collectionView.reloadData()
        
    }
}



