let pgConn = DataLayer(host: "localhost", port: "5432", database: "election")
if pgConn.connect() == true {
  print("The connection was successful")

  let elections : [String] = pgConn.getElections(electionType: "general")

  for election : String in elections {
    print(election)
    let candidates : [congressionalCandidate] = pgConn.getCongressionalCandidates(date: election, electionType: "general")
    print(candidates[0])
  }
  pgConn.disconnect()
} else {
  print("The connection was not successful")
}
