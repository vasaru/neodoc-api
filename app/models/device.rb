class Device < Neo4j::Rails::Model
  property :name, :type => String
  property :model, :type => String
  property :serialnr, :type => String
  property :label, :type => String
  property :version, :type => String
  property :description, :type => String
  property :license, :type => String

  has_n :ports
  has_n :company
  has_n :document
  has_n :ipnumber
  has_n :operatingsystem
  has_n :osversion
  has_one :location
  has_n :devicetype

  index :name
  

end
