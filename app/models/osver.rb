class Osver < Neo4j::Rails::Model
	property :name, :type => String
 	property :major, :type => String
	property :minor, :type => String
	property :build, :type => String
#	property :patch, :type => String
#	property :update, :type => String
	property :releasedate, :type => Date
#	property :patchinformation, :type => String
	property :isourl, :type => String
	property :downloadurl, :type => String
	property :description, :type => String
	property :status, :type => String

	has_one :operatingsystem

	index :name

end
