import PackageDescription

let package = Package(
    name: "election-calc",
    targets: [
      Target(
        name: "Shell",
        dependencies: [
          .Target(name: "Boundary"),
          .Target(name: "Core")
        ]
      ),
      Target(
        name: "Core",
        dependencies: [
          .Target(name: "Boundary")
        ]
      ),
      Target(
        name: "Boundary"
      )
    ],
    dependencies: [
      .Package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", versions: Version(0,0,0)..<Version(10,0,0))
    ]
)
