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
}
