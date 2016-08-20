import PackageDescription

let package = Package(
    name: "election-calc",
    dependencies: [
      .Package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", versions: Version(0,0,0)..<Version(10,0,0))
    ]
)
