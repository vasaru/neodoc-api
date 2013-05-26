class Operatingsystem < Neo4j::Rails::Model
  property :name, :type => String
  property :description, :type => String
  property :license, :type => String
  property :url, :type => String
  property :productinformation, :type => String
  property :status, :type => String

  index :name

  has_n :documents
  has_n :osversions
  has_one :manufacturer
  
end
