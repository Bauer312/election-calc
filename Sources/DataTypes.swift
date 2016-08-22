struct congressionalCandidate {
  var state : String
  var district : String
  var name : String
  var votes : Int
}

struct senateCandidate {
  var state : String
  var term : String
  var name : String
  var votes : Int
}

struct candidate {
  var name : String
  var votes : Int
}

struct contestedSeat {
  var state : String
  var district : String
  var candidates : [candidate]


}

func candidateSorter(_ this: candidate, _ that: candidate) -> Bool {
  return this.votes > that.votes
}
