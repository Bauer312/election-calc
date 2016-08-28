import Boundary

public func applyMethodology(seats: [contestedSeat]) {
  var intermediateSeats : [seatCalculation] = []
  for seat in seats {
    let seatCalc = produceRawScore(seat: seat)
    intermediateSeats.append(seatCalc)
  }

  var seatIndex = produceIntermediateScore(seats: intermediateSeats, highFilter: 100.0)
  if doUpperOutliersExist(seats: seatIndex, highValue: 65.0, lowValue: 65.0) == true {
    seatIndex = produceIntermediateScore(seats: seatIndex, highFilter: 65.0)
  }
  if doUpperOutliersExist(seats: seatIndex, highValue: 65.0, lowValue: 65.0) == true {
    seatIndex = produceIntermediateScore(seats: seatIndex, highFilter: 65.0)
  }
  if doUpperOutliersExist(seats: seatIndex, highValue: 65.0, lowValue: 65.0) == true {
    seatIndex = produceIntermediateScore(seats: seatIndex, highFilter: 65.0)
  }
  for seat in seatIndex {
    print(seat)
  }
}

func produceRawScore(seat: contestedSeat) -> seatCalculation {
  var result = createCalculation(state: seat.state, district: seat.district)

  var trimmedCandidates = trimCandidates(candidates: seat.candidates, keep: 2)

  if trimmedCandidates.count < 2 {
    result.index = 0
  } else {
    let difference = trimmedCandidates[0].votes - trimmedCandidates[1].votes
    result.index = 1.0 / Double(difference)
  }
  return result
}

func produceIntermediateScore(seats: [seatCalculation], highFilter: Double) -> [seatCalculation] {
  var result : [seatCalculation] = []
  var intermediate : [seatCalculation] = []

  for seat in seats {
    if seat.index == 0.0 {
      result.append(seat)
    } else if seat.index >= highFilter {
      var newSeat = createCalculation(state: seat.state, district: seat.district)
      newSeat.index = 100.0
      result.append(newSeat)
    } else {
      intermediate.append(seat)
    }
  }

  let min = seatMin(seats: intermediate)
  let max = seatMax(seats: intermediate)
  let denominator = max - min

  for seat in intermediate {
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
