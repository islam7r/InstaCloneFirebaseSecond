//
//  FeedViewController.swift
//  InstaCloneFirebaseSecond
//
//  Created by Islam Rzayev on 12.03.24.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var userArray = [String]()
    var commentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getDataFirestore()

    }
    
    func getDataFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                
                if snapshot?.isEmpty != true && snapshot != nil{
                    for document in snapshot!.documents{
                        if let postedBy = document.get("postedBy") as? String{
                            self.userArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String{
                            self.commentArray.append(postComment)
                        }
                        
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append("imageUrl")
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                }
                
                
//                if let postedBy = fireStoreDatabase.document("po")
                
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FeedCell
        
        cell?.userLabel.text = userArray[indexPath.row]
        cell?.userImageView.image = UIImage(named: "upload")
        cell?.commentLabel.text = commentArray[indexPath.row]
        cell?.likeLabel.text = String(likeArray[indexPath.row])
        return cell!

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
