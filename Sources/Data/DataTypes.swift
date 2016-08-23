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
