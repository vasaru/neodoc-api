class Device < Neo4j::Rails::Model
  property :name, :type => String
  property :devicetype, :type => String
  property :model, :type => String
  property :serialnr, :type => String
  property :label, :type => String
  property :version, :type => String
  property :description, :type => String
  property :license, :type => String
  property :updated_at, :type => DateTime
  property :created_at, :type => DateTime
  property :updated_by, :type => String
  property :created_by, :type => String

  has_n :ports
  has_n :company
  has_n :document
  has_n :ipnumber
  has_n :operatingsystem
  has_n :osversion
  has_one :location
  has_n :devtype
  has_n :parts
  has_one :devicecategory
  has_n :customers

  index :name
  index :devicetype
  

end
