//
//  EventListTableViewController.swift
//  AMP
//
//  Created by Michal Rewienski on 1/20/16.
//  Copyright © 2016 Toolla Inc. All rights reserved.
//

import UIKit

// This displays the list of event headers
class EventListTableViewController: ExpandableTableView {
    
    var sortedEvents: Array<Array<Event>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        loadEvents()
    }
    
    func loadEvents() {

        var tableStructureArray: [Int] = []
        
        //load events data
        for i in 0 ..< 6{
            tableStructureArray.append(0)
            var events: [Event] = []
            for j in 0 ..< 6{
                let event = Event(name: "event name + \(String(j))", month: i+1)
                events.append(event)
                
                //to save table structure 5 months and each one has 5 events
                tableStructureArray[i] = tableStructureArray[i] + 1
            }
            //divide events to sections and rows
            sortedEvents.append(events)
        }
        self.setNumberOfCategoriesAndSubcategories(tableStructureArray, useSectionHeaders: true)
    }
    
    
    
    override func sectionHeaderDesign(section: Int) -> UIView! {
        let headerView = tableView.dequeueReusableCellWithIdentifier("eventHeader") as? EventHeaderCell ?? EventHeaderCell()
     
        let month = sortedEvents[section].first!.month
        headerView.monthLabel.text = String(month)
        return headerView.contentView
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
    
    override func expandedCellDesign(indexPath: NSIndexPath) -> UITableViewCell! {
        let expandedCell = self.tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as? EventExpandedCell ?? EventExpandedCell()
        expandedCell.nameEventLabel.text = sortedEvents[indexPath.section][indexPath.row].name
        return expandedCell
    }
    
    override func onExpandedCellTap(indexPath: NSIndexPath){
        print("Expanded Cell Tapped", "section", indexPath.section, "row", indexPath.row)
    }
}


