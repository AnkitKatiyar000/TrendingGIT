//
//  ProjectListTableViewController.swift
//  TrendingGitSwift
//
//  Created by Vinove on 27/10/16.
//  Copyright © 2016 Vinove. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProjectListTableViewController: UITableViewController ,UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating{
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
 
    }

    let progressHUD = MBProgressHUD()
    var detailViewController: DetailViewController? = nil

    let searchController = UISearchController(searchResultsController: nil)
    var searchKey:String = ""
    let   projectHelper:ProjectServiceHelper=ProjectServiceHelper()
    var pageNumber:Int = 1
    var flagStopReload:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setup()
        self.loadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title="Git Trending"
    }
    
    func setup() -> Void {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .done
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        tableView.tableHeaderView = searchController.searchBar
        
        // tableView footer Clear
        tableView.tableFooterView=UIView()
    }
    
    func loadData() ->Void  {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"

        projectHelper.sendRequestForData(searchKey:self.searchKey, pageNo: pageNumber) { (result:Bool) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if result{
                self.tableView.reloadData()
                
            }else{
                self.flagStopReload=true
            }
        }
    }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projectHelper.projectListArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectListCell", for: indexPath) as! ProjectListTableViewCell

        // Configure the cell...
        cell.setProjectData(model:projectHelper.projectListArray[indexPath.row])


         return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex:NSInteger = tableView.numberOfSections - 1;
        let  lastRowIndex:NSInteger = tableView.numberOfRows(inSection: lastSectionIndex)-1
        
        if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
            // This is the last cell
            if projectHelper.projectListArray.count>29 && flagStopReload==false {
                pageNumber += 1
                self.loadData()
            }
            
        }
        

    }
    
        // MARK: - UISearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.pageNumber=1
        self.searchKey=searchBar.text!
        projectHelper.projectListArray.removeAll()
        self.loadData()
    }
   
    func  searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: - Segues
            if segue.identifier == "showDetail" {
                    let viewController:DetailViewController = segue.destination as! DetailViewController
                    viewController.projectData = projectHelper.projectListArray[(tableView.indexPathForSelectedRow?.row)!]
                }
            }
    
        



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
