// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "SideMenu",
  products: [
    .library(name: "SideMenu",  targets: ["SideMenu"])
  ],
  targets: [
    .target(name: "SideMenu", path: "Pod/Classes")
  ]
)
