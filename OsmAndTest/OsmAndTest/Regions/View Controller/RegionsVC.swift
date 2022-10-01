//
//  RegionsVC.swift
//  OsmAndTest
//
//  Created by Hasan Hasanov on 30.09.22.
//

import UIKit

class RegionsVC: UIViewController {

   
    @IBAction func backTpd(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    let downloadManager = DownloadManager.shared
    var progress: [String: Float] = [:]
    
    @IBOutlet weak var regionTableView: UITableView!{
        didSet{
            regionTableView.register(UINib(nibName: "CountriesMapCell", bundle: nil), forCellReuseIdentifier: "MapCell")
            regionTableView.delegate = self
            regionTableView.dataSource = self
        }
    }
    
    
    @IBOutlet weak var navTitle: UILabel!{
        didSet{
            navTitle.text = regions?.name.capitalizingFirstLetter()
        }
    }
    var regions: Region?
    var suffix = ""
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }
    func setupView(){
        downloadManager.delegate = self
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
extension RegionsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions?.region?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell") as! CountriesMapCell
        let id = downloadManager.generateSpecificID(name: regions?.name ?? "-", regionName: regions?.region?[indexPath.row].name ?? "-", suffix: suffix)
        cell.setupRegionsCell(region: regions?.region?[indexPath.row], progress: progress[id])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = downloadManager.generateSpecificID(name: regions?.name ?? "",regionName: regions?.region?[indexPath.row].name ?? "", suffix: suffix)
        if progress[id] == nil && regions?.region?[indexPath.row].region == nil{
            downloadManager.submitToQueue(id: id)
        }else{
            
        }
//        if progress
    }
    
}
extension RegionsVC: UpdateProgress{
    func didUpdateProgrress(progress: [String : Float]) {
        self.progress = progress
        DispatchQueue.main.async {
            self.regionTableView.reloadData()
        }
    }
}
