//
//  AlbumsViewController.swift
//  TabBarAppTask
//
//  Created by Aryan on 24/03/23.
//

import UIKit
import SDWebImage
import Foundation
struct albumApiResponce : Codable{
    let resultCount : Int
    let results : [albumVariables]
}

struct albumVariables : Codable{
    var artistName : String
    var collectionName : String?
    var artworkUrl100 : String
}


class AlbumsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    var artistCollectionArray = [albumVariables]()
    
    @IBOutlet weak var albumsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getData()
    }
    
    // TAble view ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return artistCollectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumsTableView.dequeueReusableCell(withIdentifier: "TabToTable", for: indexPath) as! AlbumTableViewCell
        cell.artistNameLabel.text = artistCollectionArray[indexPath.row].artistName
        cell.albumNameLabel.text = artistCollectionArray[indexPath.row].collectionName
        
        let imageStrng = artistCollectionArray[indexPath.row].artworkUrl100
        if let imgUrl = URL(string: imageStrng){
        cell.albumImageView.sd_setImage(with: imgUrl)
        cell.albumImageView.contentMode = .scaleAspectFill
         
        }
        
//        if let imgUrl = URL(string: artistCollectionArray[indexPath.row].artworkUrl100){
//         let data = try? Data(contentsOf: imgUrl)
//            cell.albumImageView.contentMode = .scaleAspectFill
//            cell.albumImageView.image = UIImage(data: data!)
//
//        }else {
//            cell.albumImageView.backgroundColor = .blue
//        }
        
        return cell
    }
    
    // getting data from API ----------------
    func getData(){
        
        let url = URL(string: "https://itunes.apple.com/search?term=jack+johnson&limit=25")
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self](data, responce, error) in
            if let error = error {
                debugPrint(error)
            }else if let data = data{
                // when we found our data
                do{
                    let dataFromApi = try JSONDecoder().decode(albumApiResponce.self, from: data)
                    self?.artistCollectionArray = dataFromApi.results
                    
                    
                    DispatchQueue.main.async {
                        self?.albumsTableView.reloadData()
                    }
                    
                }catch{
                    debugPrint("data is not present in api")
                }
                
            }else{
                debugPrint("you are finding some error")
            }
            
        }).resume()
    }
    
}


