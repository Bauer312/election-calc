import Boundary
import Core
import Foundation

if CommandLine.arguments.count == 2 {
  print(CommandLine.arguments[1])
}

let pgConn = DataLayer(host: "localhost", port: "5432", database: "election")
if pgConn.connect() == true {
  print("The connection was successful")
  let electionDates : [String] = pgConn.getElections(electionType: "general")
  var elections : [election] = []
  var seatText : [String] = []

  for electionDate : String in electionDates {
    print(electionDate)
    var congress = election(date: electionDate, office: "Congress")
    congress.seats = pgConn.getCongressionalCandidates(date: electionDate, electionType: "general")
    print("The congressional election has \(congress.seats.count) contested seats.")
    congress.seats = applyMethodology(seats: congress.seats, date: electionDate, office: "Congress")
    for seat in congress.seats {
      seatText.append("\(electionDate)|\(seat.state)|Congress|\(seat.district)|\(seat.index)\n")
    }

    var senate = election(date: electionDate, office: "Senate")
    senate.seats = pgConn.getSenateCandidates(date: electionDate, electionType: "general", termType: "full")
    print("The senate election has \(senate.seats.count) contested seats.")
    senate.seats = applyMethodology(seats: senate.seats, date: electionDate, office: "Senate")
    for seat in senate.seats {
      seatText.append("\(electionDate)|\(seat.state)|Senate||\(seat.index)\n")
    }

    elections.append(congress)
    elections.append(senate)
  }
  pgConn.disconnect()

  if CommandLine.arguments.count == 2 {
    do {
      var data = Data()
      for seatString in seatText {
        if let incrementalData = seatString.data(using: String.Encoding.utf8) {
          data.append(incrementalData)
        }
      }
      try data.write(to: URL(fileURLWithPath: CommandLine.arguments[1]), options: .atomic)
    } catch {
      print("Unable to write the output to \(CommandLine.arguments[1])")
    }
    print(CommandLine.arguments[1])
  }
} else {
  print("The connection was not successful")
}
