# Expandable Table View iOS Swift

This helpful extension can do expandable effects like this with some animations also:

Using rows:

![alt tag](https://github.com/rudald/expandedTableViewIOSSwift/blob/master/ExpandableTableView/rowScreenShot_37.png)

Using section headers:

![alt tag](https://github.com/rudald/expandedTableViewIOSSwift/blob/master/ExpandableTableView/sectionHeadersAndRows_37.png)

You can also check implemented example here in this repository

To use it you should:
Add this file ExpandableTableView.swift to your project and in some TableViewController extend from ExpandableTableView class.

To work it properly you should do:

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
        
      - expandedCellDesign
          
      - sectionHeaderDesign
          
      - onExpandedCellTap
            
    c) execute set NumberOfCategoriesAndSubcategories as Int Array [Int], index = section number, value = number of rows
        with second argument (useSectionHeaders) true
