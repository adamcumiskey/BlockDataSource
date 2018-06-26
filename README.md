# BlockDataSource

[![Build Status](https://www.bitrise.io/app/03ad9472067fd087.svg?token=-uPn-_hHft3sR34teylZ-w&branch=master)](https://www.bitrise.io/app/03ad9472067fd087)
[![Version](https://img.shields.io/cocoapods/v/BlockDataSource.svg?style=flat)](http://cocoapods.org/pods/BlockDataSource)
[![License](https://img.shields.io/cocoapods/l/BlockDataSource.svg?style=flat)](http://cocoapods.org/pods/BlockDataSource)
[![Platform](https://img.shields.io/cocoapods/p/BlockDataSource.svg?style=flat)](http://cocoapods.org/pods/BlockDataSource)

Conjure UITable/UICollectionViews  out of thin air.

A DataSource is an embedded DSL for construcing UIs with UITableViews and UICollectionViews. You pass in a description of your UI and the DataSource automatically conforms to `UITableViewControllerDataSource`, ` UITableViewControllerDelegate`, `UICollectionViewControllerDataSource`, and `UICollectionViewControllerDelegate`. You can then set the datasource and delegate properties of your view to the DataSource to power your UI.

For example:

```swift
```

### Reusables

The atomic unit of BlockDataSource is the Reusable. A Reusable is a data provider for some UI element that is recycled, like the view elements in collection UIs.
A reusable has both a `reuseIdentifier`, and a `configure` block that is used to modify the view's data before it is redisplayed. The initializer takes in a generic
configure block over a `UIView` subclass. Reusables can be used for creating Header and Footer views for sections.

```swift
let header = Reusable { (view: MyHeaderView) in
    header.logoImage = UIImage(named: "logo")
}
```
You must provide a type for the closure parameter to allow the initializer to infer the correct type.

### Items

Items are a more specific subclass of Reusables designed to be used for configuring UITableView and UICollectionView cells. 

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
