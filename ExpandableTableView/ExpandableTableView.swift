//
//  ExpandableTableView.swift
//  AMP
//
//  Created by Arkadiusz Rudny on 14/03/2016.
//  Copyright © 2016 Toolla Inc. All rights reserved.
//
/*
    To execute it properly you should decide that do you want to create expanded view by rows or by section headers and rows.
    
    1. To do it only by rows you should:
        a) extend the ExpandableTableView class
        b) override methods
            - selectedCellDesign
            - deselectedCellDesign
            - expandedCellDesign
            - onExpandedCellTap
        c) execute set NumberOfCategoriesAndSubcategories as Int Array [Int], index = section number, value = number of rows
        with second argument (useSectionHeaders) false
    2. Section headers + rows
        a) extend the ExpandableTableView class
        b) override methods
            - expandedCellDesign(indexPath: NSIndexPath)
            - sectionHeaderDesign(section: Int)
            - onExpandedCellTap(indexPath: NSIndexPath)
            - func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
            - func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
        c) execute set NumberOfCategoriesAndSubcategories as Int Array [Int], index = section number, value = number of rows, with second argument (useSectionHeaders) true
*/
import UIKit

class ExpandableTableView: UITableViewController{
    private var numberOfRows: Int = 0
    private var indexSelectedCategory: Int = -1
    private var numberOfElementsInCategory: Int = 0
    private var isCategorySelected: Bool = false
    private var numberOfSubcategoriesForCategory: [Int] = []
    
    private var asSectionView: Bool = false
    
    private var sectionsHeight: Array<CGFloat> = []
    private var basicSectionHeight: Array<CGFloat> = []
    private var positionOfFirstSection: CGFloat = 0
    
    private var shouldEmptyRows = false
    private var scrollToBar: Bool = false
    
    private var rowsHeight: Array<Array<Int>> = Array<Array<Int>>()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if asSectionView == true{
        
            rowsHeight[indexPath.section][indexPath.row] = Int(self.tableView(tableView, heightForRowAtIndexPath: indexPath))
            calculateHeightForSections(indexPath.section, isViewExpanded: true)
            if shouldEmptyRows == true{
                let row = expandedCellDesign(indexPath)
                for subview in row.subviews{
                    subview.removeFromSuperview()
                }
                if row.layer.sublayers != nil{
                    for sublayer in row.layer.sublayers!{
                        sublayer.removeFromSuperlayer()
                    }
                }
                return row
            }
            else{
                return expandedCellDesign(indexPath)
            }
        }
        else{
            if indexSelectedCategory > indexPath.row{
                return deselectedCellDesign(indexPath)
            }
            else if indexSelectedCategory == indexPath.row{
                return selectedCellDesign(indexPath)
            }
            else if indexSelectedCategory < indexPath.row
                && indexSelectedCategory + numberOfElementsInCategory >= indexPath.row{
                    
                    return expandedCellDesign(indexPath)
            }
            else{
                return deselectedCellDesign(indexPath)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if asSectionView == false{
            if isCategorySelected{
                //is clicked on the same Category
                if indexSelectedCategory == indexPath.row{
                    isCategorySelected = false
                    numberOfElementsInCategory = 0
                    self.tableView.reloadData()
                }
                    //if category is open and you click on another category
                else if indexPath.row < indexSelectedCategory{
                    indexSelectedCategory = indexPath.row
                    numberOfElementsInCategory = numberOfSubcategoriesForCategory[indexSelectedCategory] ?? 0
                    self.tableView.reloadData()
                }
                    //is clicked on track
                else if indexPath.row > indexSelectedCategory && indexPath.row <= indexSelectedCategory + numberOfElementsInCategory{
                    onExpandedCellTap(indexPath)
                }
                    //clicked on other Category
                else if indexPath.row > indexSelectedCategory{
                    indexSelectedCategory = indexPath.row - numberOfElementsInCategory
                    numberOfElementsInCategory = numberOfSubcategoriesForCategory[indexSelectedCategory] ?? 0
                    self.tableView.reloadData()
                }
            }
            else{
                //unroll
                indexSelectedCategory = indexPath.row
                isCategorySelected = true
                numberOfElementsInCategory = numberOfSubcategoriesForCategory[indexSelectedCategory] ?? 0
                self.tableView.reloadData()
            }
        }
        else{
            onExpandedCellTap(indexPath)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if asSectionView == true{
            return numberOfRows
        }
        else if numberOfRows != 0{
            return 1
        }
        else{
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if asSectionView == true{
            if section == indexSelectedCategory{
                //animation when rows are adding
                return self.numberOfElementsInCategory
            }
            else{
                return 0
            }
        }
        else {
            if isCategorySelected{
                return numberOfRows + numberOfElementsInCategory
            }
            else{
                return numberOfRows
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = sectionHeaderDesign(section)
        let tapOnSectionHeader = UITapGestureRecognizer(target: self, action: #selector(ExpandableTableView.sectionHeaderSelected(_:)))
        view.addGestureRecognizer(tapOnSectionHeader)
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 1.0
        return view
    }
    
    func findSectionIndex(touchedPoint: CGPoint) -> Int{
        for i in 0 ..< sectionsHeight.count{
            if (sectionsHeight[i]) > touchedPoint.y{
                return i
            }
        }
        return 0
    }
    
    
    func sectionHeaderSelected(sender: UITapGestureRecognizer){
        let touchedPoint:CGPoint = sender.locationInView(self.tableView)
        let section = findSectionIndex(touchedPoint)
        
        if isCategorySelected{
            //is clicked on the same Category
            if indexSelectedCategory == section{
                isCategorySelected = false
                calculateHeightForSections(indexSelectedCategory, isViewExpanded: false)
                //Close list animation starts
                //Collapsing the list
                if section == 0{
                    scrollToBar = true
                    self.scrollViewDidEndScrollingAnimation(self.tableView)
                }
                
                CATransaction.begin()
                self.tableView.beginUpdates()
                for i in 0 ..< self.numberOfElementsInCategory{
                    self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: section)], withRowAnimation: .Top)
                }
                self.numberOfElementsInCategory = 0
                self.tableView.endUpdates()
                
                
                CATransaction.setCompletionBlock { () -> Void in
                    usleep(400000)
                    UIView.transitionWithView(self.tableView,
                        duration:1.00,
                        options:.ShowHideTransitionViews,
                        animations:
                        { () -> Void in
                            self.tableView.reloadData()
                            self.scrollToBar = true
                            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: NSNotFound, inSection: 0), atScrollPosition: .Top, animated: true)
                            
                        },
                        completion: nil);
                }
                CATransaction.commit()
            }
            else{
                indexSelectedCategory = section
                numberOfElementsInCategory = numberOfSubcategoriesForCategory[indexSelectedCategory] ?? 0
                
                calculateHeightForSections(indexSelectedCategory, isViewExpanded: true)

                self.tableView.reloadData()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: NSNotFound, inSection: section), atScrollPosition: .Top, animated: true)
            }
        }
        else{
            //unroll
            
            indexSelectedCategory = section
            isCategorySelected = true
            numberOfElementsInCategory = numberOfSubcategoriesForCategory[indexSelectedCategory] ?? 0
            
            calculateHeightForSections(indexSelectedCategory, isViewExpanded: true)

            self.shouldEmptyRows = false
            self.tableView.reloadData()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: NSNotFound, inSection: section), atScrollPosition: .Top, animated: true)
        }
    }

    func calculateHeightForSections(selectedCategory: Int, isViewExpanded: Bool){
        let tableHeaderHeight = (tableView.tableHeaderView?.frame.height) ?? 0
        
        if isViewExpanded{
            for i in 0 ..< selectedCategory{
                sectionsHeight[i] = tableHeaderHeight + CGFloat(i+1) * basicSectionHeight[i]
            }
            var sumOfRowHeights = 0
            for k in 0 ..< numberOfElementsInCategory {
                sumOfRowHeights += rowsHeight[selectedCategory][k]
            }
            if selectedCategory > 0{
                sectionsHeight[selectedCategory] = sectionsHeight[selectedCategory - 1] + CGFloat(sumOfRowHeights) + basicSectionHeight[selectedCategory]
            }
            else{
                sectionsHeight[selectedCategory] = tableHeaderHeight +
                    CGFloat(sumOfRowHeights) + basicSectionHeight[selectedCategory]
            }
            for i in selectedCategory+1 ..< sectionsHeight.count{
                sectionsHeight[i] = sectionsHeight[i-1] + basicSectionHeight[i]
            }
        }
        else{
            for i in 0 ..< sectionsHeight.count{
                sectionsHeight[i] = tableHeaderHeight + CGFloat(i+1) * basicSectionHeight[i]
            }
        }
    }
    
    
    override func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if scrollToBar == true{
            CATransaction.begin()

            CATransaction.setCompletionBlock { () -> Void in
                UIView.transitionWithView(self.tableView,
                    duration:0.30,
                    options:.ShowHideTransitionViews,
                    animations:
                    { () -> Void in
                        var contentOffset: CGPoint = self.tableView.contentOffset
                        contentOffset.y -= (self.tableView.tableHeaderView?.frame.height) ?? 0
                        self.tableView.contentOffset = contentOffset
                    },
                    completion: nil);
            }
            CATransaction.commit()
            scrollToBar = false
        }
    }
    
    func rollUpExpandedTable(){
        isCategorySelected = false
        numberOfElementsInCategory = 0
        let tableHeaderHeight = (self.tableView.tableHeaderView?.frame.height) ?? 0
        for i in 0 ..< sectionsHeight.count{
            sectionsHeight[i] = tableHeaderHeight + CGFloat(i+1) * basicSectionHeight[i]
        }
    }
    
    func isCategoryMarked() -> Bool{
        return isCategorySelected
    }
    
    func getNumberOfElementsInCategory() -> Int{
        return numberOfElementsInCategory
    }
    
    func getIndexSelectedCategory() -> Int{
        return indexSelectedCategory
    }
    
    //Provides number of cells first category
    func setNumberOfCategoriesAndSubcategories(array: [Int], useSectionHeaders: Bool){
        self.asSectionView = useSectionHeaders
        numberOfSubcategoriesForCategory = array
        self.numberOfRows = array.count
        let tableHeaderHeight = (tableView.tableHeaderView?.frame.height) ?? 0
        
        for i in 0 ..< numberOfRows{
            rowsHeight.append(Array(count: numberOfSubcategoriesForCategory[i], repeatedValue: Int()))
            for j in 0 ..< rowsHeight[i].count{
                rowsHeight[i][j] = Int(self.tableView.rowHeight)
            }
        }
        
        if sectionsHeight.count < numberOfSubcategoriesForCategory.count{
            for i in 0 ..< numberOfSubcategoriesForCategory.count{
                basicSectionHeight.append(self.tableView(self.tableView, heightForHeaderInSection: i))
                sectionsHeight.append(tableHeaderHeight + (CGFloat(i+1) * basicSectionHeight[i]))
            }
        }
        self.tableView.reloadData()
    }
    
    
    //to override
    func sectionHeaderDesign(section:Int) -> UIView!{
        return nil
    }
    
    //to override
    func selectedCellDesign(indexPath: NSIndexPath) -> UITableViewCell!{
        return nil
    }
    
    //to override
    func expandedCellDesign(indexPath: NSIndexPath) -> UITableViewCell!{
        return nil
    }
    
    //to override
    func deselectedCellDesign(indexPath: NSIndexPath) -> UITableViewCell!{
        return nil
    }
    
    //to override
    func onExpandedCellTap(indexPath: NSIndexPath){
    }
}