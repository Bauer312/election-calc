import Boundary

public func produceRawScore(seat: contestedSeat) -> seatCalculation {
  var result = createCalculation(state: seat.state, district: seat.district)

  var trimmedCandidates = trimCandidates(candidates: seat.candidates, keep: 2)

  if trimmedCandidates.count < 2 {
    result.raw = 0
  } else {
    let difference = trimmedCandidates[0].votes - trimmedCandidates[1].votes
    result.raw = 1.0 / Double(difference)
  }
  return result
}
