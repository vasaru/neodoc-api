class Customer < Neo4j::Rails::Model
  property :name, :type => String
  property :nickname, :type => String
  property :address, :type => String
  property :city, :type => String
  property :zip, :type => String
  property :country, :type => String
  property :workphone1, :type => String
  property :workphone2, :type => String
  property :mobilephone1, :type => String
  property :mobilephone2, :type => String
  property :fax, :type => String
  property :email, :type => String
  property :url, :type => String
  property :url2, :type => String
  property :facebook, :type => String
  property :twitter, :type => String
  property :category, :type => String
  property :description, :type => String
  property :organizationnumber, :type => String
  property :updated_at, :type => DateTime
  property :created_at, :type => DateTime
  property :updated_by, :type => String
  property :created_by, :type => String
  

  index :name

  has_n :documents
  has_n :companies
  has_n :connections
  has_n :comments
  has_n :locations
  has_n :contacts

end