# Unshift

Unshift is a playground project to practice MVVM + RxSwift, Composition Root, Dependency Inversion on model layer.

* `AppDependencyResolver` is the composition root (a single location where instantiating and combining all the application dependencies happens). Pure DI is used (no DI container).
* MVVM + RxSwift is used for presentation of a single screen. The view model interface (`DemoViewModel`) consists of several independent `Driver`s (from `RxCocoa`). Still not sure whether it's convenient in a real project.
* UI is built with code, with an extensive usage of [Then](https://github.com/devxoul/Then) library, and some [SnapKit](https://github.com/SnapKit/SnapKit) under the hood. The result (`DemoViewController`) is a self-descriptive code tree, without unneccessary naming, resembling SwiftUI in some way. I like this style very much and prefer using it in other UIKit projects.
* The model consists of a single object (a forecast, describing some formal event, assigning some probability to it, and optionally resolved with some true/false outcome). To uncouple the model interface from CoreData, there is `Forecast` (a CoreData-free protocol), `ManagedForecast` (a CoreData object), `PlainForecast` (a plain structure). As a result, the interface of the services (`ForecastsService`, `ForecastVerificationService`) uses only `Forecast`, and isn't coupled with CoreData.

In retrospect, there are several mistakes:

* Calling the composition root from `SceneDelegate` is incorrect in case of several windows.
* Some composition logic is still spreaded across the project (`Model`, `Storage`).
* Screen navigation is coupled with UIKit (`UIViewController` instances are passed, unconvered with any protocol).
