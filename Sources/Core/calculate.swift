import Boundary

public func applyMethodology(seats: [contestedSeat], date: String, office: String) {
  var intermediateSeats : [seatCalculation] = []
  for seat in seats {
    let seatCalc = produceRawScore(seat: seat)
    intermediateSeats.append(seatCalc)
  }

  intermediateSeats = normalizeScore(seats: intermediateSeats)

  for seat in intermediateSeats {
    print("\(date) | \(office) | \(seat.state) | \(seat.district) | \(seat.index)")
  }
}

func produceRawScore(seat: contestedSeat) -> seatCalculation {
  var result = createCalculation(state: seat.state, district: seat.district)

  var trimmedCandidates = trimCandidates(candidates: seat.candidates, keep: 3)

  result.index = 1.0 - Double(trimmedCandidates[0].votes) / Double(seatVotes(seats: trimmedCandidates))

  return result
}

func normalizeScore(seats: [seatCalculation]) -> [seatCalculation] {
  var result : [seatCalculation] = []

  let min = seatMin(seats: seats)
  let max = seatMax(seats: seats)
  let denominator = max - min

  for seat in seats {
    var newSeat = createCalculation(state: seat.state, district: seat.district)
    newSeat.index = Double(Int(((seat.index - min) / denominator) * 100.0))
    result.append(newSeat)
  }

  return result
}

func seatMin(seats: [seatCalculation]) -> Double {
  var result: Double = seats[0].index

  for i in 1..<seats.count {
    if seats[i].index < result {
      result = seats[i].index
    }
  }

  return result
}

func seatMax(seats: [seatCalculation]) -> Double {
  var result: Double = seats[0].index

  for i in 1..<seats.count {
    if seats[i].index > result {
      result = seats[i].index
    }
  }

  return result
}

func seatVotes(seats: [candidate]) -> Int {
  var result: Int = seats[0].votes

  for i in 1..<seats.count {
    result = result + seats[i].votes
  }

  return result
}

func doUpperOutliersExist(seats: [seatCalculation], highValue: Double, lowValue: Double) -> Bool {
  var highCount = 0
  var lowCount = 0
  for seat in seats {
    if seat.index >= highValue {
      highCount += 1
    } else if seat.index >= lowValue {
      lowCount += 1
    }
  }

  if lowCount == 0 {
    if Double(highCount) / Double(seats.count) <= 0.05 {
      return true
    }
  }
  return false
}
