import Boundary
import Core

let pgConn = DataLayer(host: "localhost", port: "5432", database: "election")
if pgConn.connect() == true {
  print("The connection was successful")

  let elections : [String] = pgConn.getElections(electionType: "general")

  for election : String in elections {
    print(election)
    var congress : [contestedSeat] = pgConn.getCongressionalCandidates(date: election, electionType: "general")
    var senate : [contestedSeat] = pgConn.getSenateCandidates(date: election, electionType: "general", termType: "full")
    print(congress[4])
    print(senate[7])
  }
  pgConn.disconnect()
} else {
  print("The connection was not successful")
}
