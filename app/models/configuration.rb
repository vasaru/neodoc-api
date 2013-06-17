class Configuration < Neo4j::Rails::Model
  property :name, :type => String
  property :description, :type => String
  property :category, :type => String
  property :value, :type => String

  index :name
  index :category
  
end
