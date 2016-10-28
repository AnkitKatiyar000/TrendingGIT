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
    
    let   projectHelper:ProjectServiceHelper=ProjectServiceHelper()
    let searchController = UISearchController(searchResultsController: nil)
    var searchKey:String = ""
    var pageNumber:Int = 1
    var flagStopReload:Bool = false
    
    
     // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.loadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title="Github Trends"
    }
    
    // MARK: - Table view data source
     override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return projectHelper.projectListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectListCell", for: indexPath) as! ProjectListTableViewCell
        
        // bind data with cell
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        flagStopReload=false
    }
    // MARK: - Custom Methods
    
    func setup() -> Void {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .done
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the table Bar
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
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
            let viewController:DetailViewController = segue.destination as! DetailViewController
            viewController.projectData = projectHelper.projectListArray[(tableView.indexPathForSelectedRow?.row)!]
            self.title="Back"
        }
    }
    
    
}
