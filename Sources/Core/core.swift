import Boundary

// Sort candidates from highest number of votes to lowest number of votes
func candidateSorter(_ this: candidate, _ that: candidate) -> Bool {
  return this.votes > that.votes
}

// Ensure that only a specified number of candidates remain
func trimCandidates(candidates: [candidate], keep: Int) -> [candidate] {
  return Array(candidates[0...keep])
}

public func processCandidates(seat: contestedSeat) -> contestedSeat {
  var result = seat
  //result.candidates.sort(by: candidateSorter)
  //result.candidates = trimCandidates(candidates: seat.candidates, keep: 2)
  return result
}
