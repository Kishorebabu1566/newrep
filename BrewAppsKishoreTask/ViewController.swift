//
//  ViewController.swift
//  BrewAppsKishoreTask
//
//  Created by Kishore Babu on 30/11/21.
//

import UIKit
import CoreData

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var moviesCV: UICollectionView!
    var nowPlayingListDataSource = NowPlayingViewModel()
    var nowPlayingListData : [NowPlayingResults]!
    
    var trailerListDataSource = TrailerViewModel()
    var trailerListData : [TrailerResults]!
    
    var addedCartItemsGet: [NSManagedObject] = []
    
    var appDelegate:AppDelegate!
    var votingArr = [Int]()
    var moc:NSManagedObjectContext!
    
    var moviesEntity:NSEntityDescription!
    var reloadDataArr = [String]()
    
    
    var isFiltering = false
    
    var filteredNames = [String]()
    
    
    
    let colourView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 5
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 13.0, *) {
            colourView.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
        
        UIApplication.shared.windows.forEach { window in
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = .dark
            } else {
                // Fallback on earlier versions
            }
        }
        
        nowPlayingListDataSource.delegate = self
        nowPlayingListDataSource.nowPlaingApi()
        
        trailerListDataSource.delegate = self
        trailerListDataSource.trailerApi()
        
        moviesCV.delegate = self
        moviesCV.dataSource = self
        
        
        moviesCV.register(UINib(nibName: "PopularMoviesCVC", bundle: nil), forCellWithReuseIdentifier: "PopularMoviesCVC")
        moviesCV.register(UINib(nibName: "UnPopularMoviesCVC", bundle: nil), forCellWithReuseIdentifier: "UnPopularMoviesCVC")
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        moc = appDelegate.persistentContainer.viewContext
        moviesEntity = NSEntityDescription.entity(forEntityName: "MovieList", in: moc)
        
        // Do any additional setup after loading the view.
    }
    
    //    SEARCH BAR METHODS:
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isFiltering = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        self.moviesCV.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        isFiltering = true
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let searchText = searchBar.text else {
            isFiltering = false
            return
        }
        
        filteredNames =  reloadDataArr.filter({
            
            return $0.lowercased().contains(searchText.lowercased())
        })
        
        isFiltering = filteredNames.count > 0
        
        self.moviesCV.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredNames.count
        } else {
            
            if addedCartItemsGet.count > 1 {
                
                return addedCartItemsGet.count
            }
            
            return 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var mo = addedCartItemsGet[indexPath.row]
        if filteredNames.count > 0 {
            if let index = reloadDataArr.firstIndex(of: filteredNames[indexPath.row]) {
               
                mo = addedCartItemsGet[index]
            }
        }
        if mo.value(forKey: "voteAvg") as! Int >= 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCVC", for: indexPath) as! PopularMoviesCVC
            cell.layer.cornerRadius = 8
            
            if isFiltering && "\(mo.value(forKey: "title")!)" == filteredNames[indexPath.row]{
                
                let url = URL(string: "\(APIList.init().imageURL)\(mo.value(forKey: "imagePath")!)")
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    cell.popularMovieImg.image = UIImage(data: imageData)
                    cell.popularMovieImg.contentMode = .scaleToFill
                }
                cell.deleteBtn.addTarget(self, action: #selector(deletePopularCell(sender:)), for: .touchUpInside)
                cell.deleteBtn.tag = indexPath.row
            } else {
                let url = URL(string: "\(APIList.init().imageURL)\(mo.value(forKey: "imagePath")!)")
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    cell.popularMovieImg.image = UIImage(data: imageData)
                    cell.popularMovieImg.contentMode = .scaleToFill
                }
                cell.deleteBtn.addTarget(self, action: #selector(deletePopularCell(sender:)), for: .touchUpInside)
                cell.deleteBtn.tag = indexPath.row
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnPopularMoviesCVC", for: indexPath) as! UnPopularMoviesCVC
            cell.layer.cornerRadius = 8
            if isFiltering && "\(mo.value(forKey: "title")!)" == filteredNames[indexPath.row]{
                cell.movieTitleLbl.text = "\(mo.value(forKey: "title")!)"
                cell.movieDescriptionLbl.text = "\(mo.value(forKey: "overview")!)"
                let url = URL(string: "\(APIList.init().imageURL)\(mo.value(forKey: "imagePath")!)")
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    cell.unPopularMovieImg.image = UIImage(data: imageData)
                    cell.unPopularMovieImg.contentMode = .scaleToFill
                }
                cell.deleteBtn.addTarget(self, action: #selector(deleteUnPopularCell(sender:)), for: .touchUpInside)
                cell.deleteBtn.tag = indexPath.row
            }else {
                cell.movieTitleLbl.text = "\(mo.value(forKey: "title")!)"
                cell.movieDescriptionLbl.text = "\(mo.value(forKey: "overview")!)"
                let url = URL(string: "\(APIList.init().imageURL)\(mo.value(forKey: "imagePath")!)")
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    cell.unPopularMovieImg.image = UIImage(data: imageData)
                    cell.unPopularMovieImg.contentMode = .scaleToFill
                }
                cell.deleteBtn.addTarget(self, action: #selector(deleteUnPopularCell(sender:)), for: .touchUpInside)
                cell.deleteBtn.tag = indexPath.row
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var select = addedCartItemsGet[indexPath.row]
        
        if filteredNames.count > 0 {
            if let index = reloadDataArr.firstIndex(of: filteredNames[indexPath.row]) {
               
                select = addedCartItemsGet[index]
            }
        }
        
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        
        let url = "\(APIList.init().imageURL)\(select.value(forKey: "imagePath")!)"
        vc.imgURLString = url
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    @objc func deletePopularCell(sender : UIButton){
        
        
        do {
            let mo = addedCartItemsGet[sender.tag]
            moc.delete(mo)
        }
        catch {
            // Do something in response to error condition
        }
        do {
            try moc.save()
        } catch {
            // Do something in response to error condition
        }
        reloadDataArr.remove(at: sender.tag)
        fetchMovieData()
        //  moviesCV.reloadData()
        // moviesCV.reloadData()
    }
    @objc func deleteUnPopularCell(sender : UIButton){
        
        
        do {
            let mo = addedCartItemsGet[sender.tag]
            moc.delete(mo)
        }
        catch {
            // Do something in response to error condition
        }
        do {
            try moc.save()
        } catch {
            // Do something in response to error condition
        }
        reloadDataArr.remove(at: sender.tag)
        fetchMovieData()
        //moviesCV.reloadData()
    }
    func delete(AddCartItem : MovieList){
        
        do {
            
            moc.delete(AddCartItem)
            
        }
        catch {
            // Do something in response to error condition
        }
        
        do {
            try moc.save()
        } catch {
            // Do something in response to error condition
        }
        
        moviesCV.reloadData()
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var mo = addedCartItemsGet[indexPath.row]
        if filteredNames.count > 0 {
            if let index = reloadDataArr.firstIndex(of: filteredNames[indexPath.row]) {
              
                mo = addedCartItemsGet[index]
            }
        }
        if mo.value(forKey: "voteAvg") as! Int >= 7 {
        
        return CGSize(width: collectionView.frame.size.width, height: 260)
        }else {
            return CGSize(width: collectionView.frame.size.width, height: 300)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
    }
    
    func fetchMovieData(){
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieList")
        addedCartItemsGet.removeAll()
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            addedCartItemsGet = try moc.fetch(fetchRequest)
            
            
            
            if addedCartItemsGet.count > 0
            {
                
                moviesCV.reloadData()
            }else{
                print("fetchError")
            }
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    
}

extension ViewController: NowPlayingDelegate {
    func didRecieveNowPlaingUpdate(data: NowPlayingData) {
        if (data.results != nil) {
            nowPlayingListData = data.results!
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieList")
            
            /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
            do {
                addedCartItemsGet = try moc.fetch(fetchRequest)
              
               
                if addedCartItemsGet.count > 0
                {
                    for j in 0..<addedCartItemsGet.count {
                        do {
                            let mo = addedCartItemsGet[j]
                            moc.delete(mo)
                        }
                        catch {
                            // Do something in response to error condition
                        }
                        do {
                            try moc.save()
                        } catch {
                            // Do something in response to error condition
                        }
                    }
                    
                }
                
                for i in 0..<nowPlayingListData!.count {
                    reloadDataArr.append(nowPlayingListData[i].original_title!)
                    votingArr.append(Int(nowPlayingListData[i].vote_average!))
                    
                    
                    let moviesMO = NSManagedObject(entity: moviesEntity, insertInto: moc)
                    
                    moviesMO.setValue(nowPlayingListData[i].vote_average!, forKey: "voteAvg")
                    moviesMO.setValue(nowPlayingListData[i].original_title!, forKey: "title")
                    moviesMO.setValue(nowPlayingListData[i].poster_path!, forKey: "imagePath")
                    moviesMO.setValue(nowPlayingListData[i].overview!, forKey: "overview")
                    
                    do{
                        try moc.save()
                        print("data saved")
                    }catch{
                        print("Data not saved")
                    }
                }
                
                
            }
            catch {
                
            }
            
            fetchMovieData()
            
        }
    }
    func didFailNowPlayingUpdateWithError(error: Error) {
        print("failure")
    }
    
    
}

extension ViewController: TrailerDelegate {
    func didRecieveTrailerUpdate(data: TrailerData) {
        print("success")
    }
    
    func didFailTrailerUpdateWithError(error: Error) {
        print("failure")
    }
    
    
}
