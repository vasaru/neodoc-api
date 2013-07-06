class Operatingsystem < Neo4j::Rails::Model
  property :name, :type => String
  property :description, :type => String
  property :license, :type => String
  property :url, :type => String
  property :productinformation, :type => String
  property :status, :type => String
  property :updated_at, :type => DateTime
  property :created_at, :type => DateTime
  property :updated_by, :type => String
  property :created_by, :type => String

  index :name

  has_n :documents
  has_n :osversions
  has_one :manufacturer
  
end
