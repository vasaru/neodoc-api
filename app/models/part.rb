class Part < Neo4j::Rails::Model
  property :name, :type => String
  property :model, :type => String
  property :serialnr, :type => String
  property :type, :type => String
  property :amount, :type => String
  property :amountmetric, :type => String
  property :version, :type => String
  property :description, :type => String

  has_n :ports
  has_n :company
  has_n :document
  has_one :device
  has_one :location

  index :name
  index :type
  

end
