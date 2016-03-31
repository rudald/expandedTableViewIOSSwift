# Expandable Table View iOS Swift

This helpful extension can do expandable effects like this with some animations also:

Using rows:

![alt tag](https://github.com/rudald/expandedTableViewIOSSwift/blob/master/ExpandableTableView/rowScreenShot_37.png)

Using section headers:

![alt tag](https://github.com/rudald/expandedTableViewIOSSwift/blob/master/ExpandableTableView/sectionHeadersAndRows_37.png)

You can also check implemented example here in this repository

To work it properly you should do:

  1. To do it only by rows you should:
  
    a) Add ExpandableTableView.swift file to your project and subclass your class by ExpandableTableView class
    
    b) override methods
    
      - selectedCellDesign
      
      - deselectedCellDesign
      
      - expandedCellDesign
      
      - onExpandedCellTap
  
    c) execute set NumberOfCategoriesAndSubcategories as Int Array [Int], index = section number, value = number of rows
        with second argument (useSectionHeaders) false
        
  2. Section headers + rows
  
    a) Add ExpandableTableView.swift file to your project and subclass your class by ExpandableTableView class
        
    b) override methods
        
      - expandedCellDesign
          
      - sectionHeaderDesign
          
      - onExpandedCellTap
            
    c) execute set NumberOfCategoriesAndSubcategories as Int Array [Int], index = section number, value = number of rows
        with second argument (useSectionHeaders) true

To roll up the category you should use <b> rollUpExpandedTable() </b> function

If you need any useful method inside class please let me know.
