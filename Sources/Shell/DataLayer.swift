import PostgreSQL
import Boundary
import Core

public class DataLayer {
  var connectionString: String
  var db : PGConnection



  public init(host: String, port: String, database: String) {
    connectionString = "host=" + host
    connectionString += " port=" + port
    connectionString += " dbname=" + database

    db = PGConnection()
  }

  public func connect () -> Bool {
    let connectionResult : PGConnection.StatusType = db.connectdb(connectionString)
    if connectionResult == .ok {
      return true
    } else {
      return false
    }
  }

  public func disconnect () {
    db.close()
  }

  func exec (statement: String) -> PGResult {
    return db.exec(statement: statement)
  }

  public func getElections(electionType: String) -> [String] {
    var result : [String] = []
    var statement = "SELECT DISTINCT election_date FROM federal.federal_rep WHERE election_type = \'"
    statement += electionType
    statement += "\' ORDER BY election_date DESC"
    let queryresult : PGResult = db.exec(statement : statement)
    let numRows = queryresult.numTuples()
    for i in 0..<numRows {
      if let value : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 0) {
        result.append(value)
      }
    }

    return result
  }

  public func getCongressionalCandidates(date: String, electionType: String) -> [contestedSeat] {
    var seats : [contestedSeat] = []
    var seatIndex = 0
    var currentState = "None"
    var currentDistrict = "None"

    var statement = "SELECT state, district, candidate, sum(votes) FROM federal.federal_rep"
    statement += " WHERE election_date = \'"
    statement += date
    statement += "\' AND election_type = \'"
    statement += electionType
    statement += "\' GROUP BY state, district, candidate ORDER BY state, district, candidate"
    let queryresult : PGResult = db.exec(statement : statement)
    let numRows = queryresult.numTuples()
    for i in 0..<numRows {
      if let stateValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 0) {
        if let districtValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 1) {
          if let candidateValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 2) {
            if let voteValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 3) {
              if let intVoteValue : Int = Int(voteValue) {
                //If we have yet to see this combination before, create it and
                //then start appending candidates to it
                if stateValue != currentState || districtValue != currentDistrict {
                  //Before adding the new seat, process the current one
                  if seats.count > 0 {
                    seats[seatIndex].candidates.sort(by: candidateSorter)
                    seats[seatIndex].candidates = trimCandidates(candidates: seats[seatIndex].candidates, keep: 2)
                  }

                  seats.append(
                    createSeat(state: stateValue, district: districtValue)
                  )
                  currentState = stateValue
                  currentDistrict = districtValue
                  seatIndex = seats.count - 1
                }

                seats[seatIndex].candidates.append(
                  createCandidate(name: candidateValue, votes: intVoteValue)
                )
              }
            }
          }
        }
      }
    }
    //Before returning, process the last one
    if seats.count > 0 {
      seats[seatIndex].candidates.sort(by: candidateSorter)
      seats[seatIndex].candidates = trimCandidates(candidates: seats[seatIndex].candidates, keep: 2)
    }
    return seats
  }

  public func getSenateCandidates(date: String, electionType: String, termType: String) -> [contestedSeat] {
    var seats : [contestedSeat] = []
    var seatIndex = 0
    var currentState = "None"

    var statement = "SELECT state, candidate, sum(votes) FROM federal.federal_sen"
    statement += " WHERE election_date = \'"
    statement += date
    statement += "\' AND election_type = \'"
    statement += electionType
    statement += "\' AND term_type = \'"
    statement += termType
    statement += "\' GROUP BY state, candidate ORDER BY state, candidate"
    let queryresult : PGResult = db.exec(statement : statement)
    let numRows = queryresult.numTuples()
    for i in 0..<numRows {
      if let stateValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 0) {
        if let candidateValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 1) {
          if let voteValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 2) {
            if let intVoteValue : Int = Int(voteValue) {
              //If we have yet to see this before, create it and
              //then start appending candidates to it
              if stateValue != currentState {
                //Before adding the new seat, process the current one
                if seats.count > 0 {
                  seats[seatIndex].candidates.sort(by: candidateSorter)
                  seats[seatIndex].candidates = trimCandidates(candidates: seats[seatIndex].candidates, keep: 2)
                }
                
                seats.append(
                  createSeat(state: stateValue, district: "None")
                )
                currentState = stateValue
                seatIndex = seats.count - 1
              }

              seats[seatIndex].candidates.append(
                createCandidate(name: candidateValue, votes: intVoteValue)
              )
            }
          }
        }
      }
    }
    //Before returning, process the last one
    if seats.count > 0 {
      seats[seatIndex].candidates.sort(by: candidateSorter)
      seats[seatIndex].candidates = trimCandidates(candidates: seats[seatIndex].candidates, keep: 2)
    }
    return seats
  }
}
