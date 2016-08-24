public class election {
  public var date : String
  public var office : String
  public var seats : [contestedSeat]

  public init(date: String, office: String) {
    self.date = date
    self.office = office
    self.seats = []
  }
}

public struct candidate {
  public var name : String
  public var votes : Int
}

public struct contestedSeat {
  public var state : String
  public var district : String
  public var candidates : [candidate]
}

public func createSeat(state: String, district: String) -> contestedSeat {
  return contestedSeat(state: state, district: district, candidates: [])
}

public func createCandidate(name: String, votes: Int) -> candidate {
  return candidate(name: name, votes: votes)
}
