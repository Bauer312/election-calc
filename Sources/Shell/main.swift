import Boundary
import Core

let pgConn = DataLayer(host: "localhost", port: "5432", database: "election")
if pgConn.connect() == true {
  print("The connection was successful")
  let electionDates : [String] = pgConn.getElections(electionType: "general")
  var elections : [election] = []

  for electionDate : String in electionDates {
    print(electionDate)
    var congress = election(date: electionDate, office: "Congress")
    congress.seats = pgConn.getCongressionalCandidates(date: electionDate, electionType: "general")
    print("The congressional election has \(congress.seats.count) contested seats.")
    for seat in congress.seats {
      print(seat)
    }

    var senate = election(date: electionDate, office: "Senate")
    senate.seats = pgConn.getSenateCandidates(date: electionDate, electionType: "general", termType: "full")
    print("The senate election has \(senate.seats.count) contested seats.")
    for seat in senate.seats {
      print(seat)
    }

    elections.append(congress)
    elections.append(senate)
  }
  pgConn.disconnect()
} else {
  print("The connection was not successful")
}
