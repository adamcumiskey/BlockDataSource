# BlockDataSource

[![Build Status](https://www.bitrise.io/app/03ad9472067fd087.svg?token=-uPn-_hHft3sR34teylZ-w&branch=master)](https://www.bitrise.io/app/03ad9472067fd087)
[![Version](https://img.shields.io/cocoapods/v/BlockDataSource.svg?style=flat)](http://cocoapods.org/pods/BlockDataSource)
[![License](https://img.shields.io/cocoapods/l/BlockDataSource.svg?style=flat)](http://cocoapods.org/pods/BlockDataSource)
[![Platform](https://img.shields.io/cocoapods/p/BlockDataSource.svg?style=flat)](http://cocoapods.org/pods/BlockDataSource)

Conjure UITable/UICollectionViews  out of thin air.

A DataSource is an embedded DSL for construcing UIs with UITableViews and UICollectionViews. 
You define the structure of your list and DataSource  will automatically conform to `UITableViewControllerDataSource`, ` UITableViewControllerDelegate`, `UICollectionViewControllerDataSource`, and `UICollectionViewControllerDelegate`. 

For example:

```swift
let vc = BlockTableViewController(
    style: .grouped,
    dataSource: DataSource(
        sections: [
            Section(
                items: [
                    Item { (cell: BedazzledTableViewCell) in
                        cell.titleLabel.text = "Custom cells"
                    },
                    Item { (cell: SubtitleTableViewCell) in
                        cell.textLabel?.text = "Load any cell with ease"
                        cell.detailTextLabel?.text = "BlockDataSource automatically registers and loads the correct cell by using the class specified in the configure block."
                        cell.detailTextLabel?.numberOfLines = 0
                    }
                ]
            )
        ],
        middleware: [
            Middleware.noCellSelectionStyle,
            Middleware.separatorInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        ]
    )
)
```

### Reusables

The atomic unit of BlockDataSource is the Reusable. A Reusable is a data provider for some UI element that is recycled, like the view elements in collection UIs.
A reusable has both a `reuseIdentifier`, and a `configure` block that is used to modify the view's data before it is redisplayed. The initializer takes in a generic
configure block over a `UIView` subclass. Reusables can be used to create `UITableViewHeaderFooterView` and `UICollectionReusableView`s for sections.

```swift
let header = Reusable { (view: MyHeaderView) in
    header.logoImage = UIImage(named: "logo")
}
```
You must provide a type for the closure parameter to allow the initializer to infer the correct type.

### Items

Items are a more specific subclass of Reusables designed to be used for `UITableViewCell` and `UICollectionViewCell`s.
If an item is `reorderable`, it will become interactive while editing if the `DataSource` has an `onReorder` block.


### Middleware


## Installation

BlockDataSource is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BlockDataSource"
```

## Author

Adam Cumiskey, adam.cumiskey@gmail.com

## License

BlockDataSource is available under the MIT license. See the LICENSE file for more info.
