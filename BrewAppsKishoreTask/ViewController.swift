//
//  ViewController.swift
//  BrewAppsKishoreTask
//
//  Created by Kishore Babu on 30/11/21.
//

import UIKit
import CoreData

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    @IBOutlet weak var moviesCV: UICollectionView!
    var nowPlayingListDataSource = NowPlayingViewModel()
    var nowPlayingListData : [NowPlayingResults]!
    
    var trailerListDataSource = TrailerViewModel()
    var trailerListData : [TrailerResults]!
    
    var appDelegate:AppDelegate!
    var votingArr = [Int]()
    var moc:NSManagedObjectContext!
    
    var moviesEntity:NSEntityDescription!
    var reloadDataArr = NSArray()
//    var votingArr:[Array<Any>]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesCV.delegate = self
        moviesCV.dataSource = self
        
//        self.moviesCV?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)

        moviesCV.register(UINib(nibName: "PopularMoviesCVC", bundle: nil), forCellWithReuseIdentifier: "PopularMoviesCVC")
        moviesCV.register(UINib(nibName: "UnPopularMoviesCVC", bundle: nil), forCellWithReuseIdentifier: "UnPopularMoviesCVC")
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        moc = appDelegate.persistentContainer.viewContext
        moviesEntity = NSEntityDescription.entity(forEntityName: "MovieList", in: moc)
//        moviesCV.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        nowPlayingListDataSource.delegate = self
        nowPlayingListDataSource.nowPlaingApi()
        
        trailerListDataSource.delegate = self
        trailerListDataSource.trailerApi()
    }
//     func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutableRawPointer) {
//        if let observedObject = object as? UICollectionView, observedObject == self.moviesCV {
//            print(change)
//        }
//    }
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if let observedObject = object as? UICollectionView, observedObject == self.moviesCV {
//                    print("completed")
//                }
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.moviesCV?.removeObserver(self, forKeyPath: "contentSize")
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if nowPlayingListData != nil {
            if nowPlayingListData.count > 0 {
               
                return nowPlayingListData.count
            }
        }
            return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if nowPlayingListData[indexPath.row].vote_average! >= 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMoviesCVC", for: indexPath) as! PopularMoviesCVC
            cell.layer.cornerRadius = 8
            let url = URL(string: "\(APIList.init().imageURL)\(nowPlayingListData[indexPath.row].poster_path!)")
            let data = try? Data(contentsOf: url!)

            if let imageData = data {
                cell.popularMovieImg.image = UIImage(data: imageData)
                cell.popularMovieImg.contentMode = .scaleAspectFill
            }
            cell.deleteBtn.addTarget(self, action: #selector(deleteCells(sender:)), for: .touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnPopularMoviesCVC", for: indexPath) as! UnPopularMoviesCVC
            cell.layer.cornerRadius = 8
            cell.movieTitleLbl.text = "\(nowPlayingListData[indexPath.row].original_title!)"
            cell.movieDescriptionLbl.text = "\(nowPlayingListData[indexPath.row].overview!)"
            let url = URL(string: "\(APIList.init().imageURL)\(nowPlayingListData[indexPath.row].poster_path!)")
            let data = try? Data(contentsOf: url!)

            if let imageData = data {
                cell.unPopularMovieImg.image = UIImage(data: imageData)
                cell.unPopularMovieImg.contentMode = .scaleAspectFill
            }
            cell.deleteBtn.addTarget(self, action: #selector(deleteCells(sender:)), for: .touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            return cell
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        
        let url = "\(APIList.init().imageURL)\(nowPlayingListData[indexPath.row].poster_path!)"
        vc.imgURLString = url
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func deleteCells(sender : UIButton){
                
        var fetchMovieList = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieList")
        
        do{
            var storedObject = try moc.fetch(fetchMovieList)
            print(storedObject.count)
          //  for i in 0..<storedObject.count{
        print(storedObject)
            var storedMO = storedObject[sender.tag] as! NSManagedObject
                moc.delete(storedMO)
                print("data deleted")
                
          //  }
        }catch{
            print("not deleted")
        }
        moviesCV.reloadData()
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if nowPlayingListData[indexPath.row].vote_average! >= 7 {
            
            return CGSize(width: collectionView.frame.size.width, height: 200)
            
        }else{
            
            return CGSize(width: collectionView.frame.size.width, height: 300)
            
        }
        
        
        
//        var width = collectionView.frame.width/2
//        width = width - 10
//        print(width)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
            return 10
        
    }
    
    func fetchMovieData(){
        var fetchMovieList = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieList")

        do{
           var storedObject = try moc.fetch(fetchMovieList)
            print(storedObject.count)
            for i in 0..<storedObject.count{
                var storedMO = storedObject[i] as! NSManagedObject
                print(storedMO.value(forKey: "voteAvg")!)
                print(storedMO.value(forKey: "title")!)
                print(storedMO.value(forKey: "imagePath")!)
                print(storedMO.value(forKey: "overview")!)
            }
        }catch{

        }
        
       
    }
    
    
}

extension ViewController: NowPlayingDelegate {
    func didRecieveNowPlaingUpdate(data: NowPlayingData) {
        if (data.results != nil) {
            nowPlayingListData = data.results!
            
            for i in 0..<nowPlayingListData!.count {

//                votingArr.append(Int(nowPlayingListData[i].vote_average!))
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
            
            fetchMovieData()
            
            
            moviesCV.reloadData()
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
