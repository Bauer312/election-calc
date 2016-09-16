import Boundary

// Sort candidates from highest number of votes to lowest number of votes
public func candidateSorter(_ this: candidate, _ that: candidate) -> Bool {
  return this.votes > that.votes
}

// Ensure that only a specified number of candidates remain
public func trimCandidates(candidates: [candidate], keep: Int) -> [candidate] {
  guard candidates.count > keep else {
    return candidates
  }

  return Array(candidates[0..<keep])
}
