# Vine

[![CI Status](https://img.shields.io/travis/Adam/Vine.svg?style=flat)](https://travis-ci.org/Adam/Vine)
[![Version](https://img.shields.io/cocoapods/v/Vine.svg?style=flat)](https://cocoapods.org/pods/Vine)
[![License](https://img.shields.io/cocoapods/l/Vine.svg?style=flat)](https://cocoapods.org/pods/Vine)
[![Platform](https://img.shields.io/cocoapods/p/Vine.svg?style=flat)](https://cocoapods.org/pods/Vine)

## Introduction

A Vine is a child that weakly retains and controls its Root. 

The Root type needs to

  1. Strongly retain the Vine
  1. Assign `vine.root = self` in the initializer
  1. Call `vine.start()` after the Root has finished initializing

When creating a Vine, the `init(start: StartFunction?)` can be used to pass in a closure that will get executed when `start()` is called.
This should be sufficient for most cases where only some initial bootstrapping logic needs to occur.
If you need a more advanced Vine

Vines are especially useful as an alternative to the Coordinator pattern for managing navigation.
![Vine Example](images/vine_example.png)

## Motivation

Removing navigation logic from view controllers is a good way to separate concerns and increase testability.
The [Coordinator](http://khanlou.com/2015/10/coordinators-redux/) pattern has been written about extensively,
and is widely accepted. However this pattern causes significant memory management overhead and makes
it dangerous to use UIKit navigation methods directly.

Coordinators store a reference to a root UIKit object and an array of child coordinators. When adding a new view controller
with a child coordinator, the parent must hold a strong reference to the child to prevent it from getting deallocated.
When the child view controller is removed, the child coordinator reference also needs to be removed from the parent.
But what happens when a someone doesn't feel like delegating a dismiss command through 4 layers of coordinators and
just calls `dismiss(animated:completion:)` from a random view controller? If that view controller is managed by a coordinator, the coordinator won't
get removed until its parent is removed. If that coordinator is strongly retaining view controllers (quite common from what I've seen)
they will also stay stuck in memory even though they are no longer on screen.

For example, a coordinator managing a UINavigationController stack receives a message to present a modal.
![Uncoordinated 1](images/uncoordinated_1.png)
The coordinator creates the modal view controller along with a coordinator to manage it.
The view controller is presented from the topViewController and the child coordinator is attached to the parent.
![Uncoordinated 2](images/uncoordinated_2.png)
The modal view controller calls `dismiss(animated:completion:)` without telling the parent Coordinator
![Uncoordinated 3](images/uncoordinated_3.png)
The modal view controller is dismissed, but the Child Coordinator still holds a reference to it.
![Uncoordinated 4](images/uncoordinated_4.png)
Both the child coordinator and any view controllers strongly referenced are now leaked.

Creating a separate object graph for navigation logic introduces the overhead of maintaining parity with the UI tree, 
and failure to do so results in memory leaks. This bookkeeping is often tedious, error prone, and results in a web of
dependencies. Vines allow you to safely call any UIKit navigation method from any Vine without causing a memory leak.
For example, if a Vine was powering a model UINavigationController with a few view controllers on the stack, it is safe to call
`self.dismiss(animated:completion:)` from any of the view controllers.
For this reason **Vine** takes the opinion that it's better to rely on view lifecycle for memory management in UI applications.

## Installation

**Vine** is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Vine'
```

## Author

Adam Cumiskey, adam.cumiskey@gmail.com

## License
**Vine** is available under the MIT license. See the LICENSE file for more info.
