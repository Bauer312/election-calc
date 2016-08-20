import PostgreSQL

class DataLayer {
  var connectionString: String
  var db : PGConnection



  init(host: String, port: String, database: String) {
    connectionString = "host=" + host
    connectionString += " port=" + port
    connectionString += " dbname=" + database

    db = PGConnection()
  }

  func connect () -> Bool {
    let connectionResult : PGConnection.StatusType = db.connectdb(connectionString)
    if connectionResult == .ok {
      return true
    } else {
      return false
    }
  }

  func disconnect () {
    db.close()
  }

  func exec (statement: String) -> PGResult {
    return db.exec(statement: statement)
  }

  func getElections(electionType: String) -> [String] {
    var result : [String] = []
    var statement = "SELECT DISTINCT election_date FROM federal.federal_rep WHERE election_type = \'"
    statement += electionType
    statement += "\' ORDER BY election_date DESC"
    let queryresult : PGResult = pgConn.exec(statement : statement)
    let numRows = queryresult.numTuples()
    for i in 0..<numRows {
      if let value : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 0) {
        result.append(value)
      }
    }

    return result
  }

  func getCongressionalCandidates(date: String, electionType: String) -> [congressionalCandidate] {
    var result : [congressionalCandidate] = []

    var statement = "SELECT state, district, candidate, sum(votes) FROM federal.federal_rep"
    statement += " WHERE election_date = \'"
    statement += date
    statement += "\' AND election_type = \'"
    statement += electionType
    statement += "\' GROUP BY state, district, candidate ORDER BY state, district, candidate"
    let queryresult : PGResult = pgConn.exec(statement : statement)
    let numRows = queryresult.numTuples()
    for i in 0..<numRows {
      if let stateValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 0) {
        if let districtValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 1) {
          if let candidateValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 2) {
            if let voteValue : String = queryresult.getFieldString(tupleIndex: i, fieldIndex: 3) {
              if let intVoteValue : Int = Int(voteValue) {
                result.append(congressionalCandidate(
                  state: stateValue,
                  district: districtValue,
                  name: candidateValue,
                  votes : intVoteValue))
              }
            }
          }
        }
      }
    }

    return result
  }
}
