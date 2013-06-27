class Contact < Neo4j::Rails::Model
  property :name, :type => String
  property :nickname, :type => String
  property :jobtitle, :type => String
  property :sex, :type => String
  property :birthday, :type => Date
  property :address, :type => String
  property :country, :type => String
  property :workphone1, :type => String
  property :workphone2, :type => String
  property :homephone, :type => String
  property :mobilephone1, :type => String
  property :mobilephone2, :type => String
  property :email, :type => String
  property :email2, :type => String
  property :url, :type => String
  property :url2, :type => String
  property :skype, :type => String
  property :msn, :type => String
  property :icq, :type => String
  property :facebook, :type => String
  property :twitter, :type => String
  property :officenr, :type => String
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

end