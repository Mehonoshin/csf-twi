MONGOURI = 'mongodb://localhost:27017'
DBNAME = "csf-twi"
MongoMapper.connection = Mongo::Connection.from_uri(MONGOURI)
MongoMapper.database = DBNAME
MongoMapper.connection.connect
