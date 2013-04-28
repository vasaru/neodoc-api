class Location < Neo4j::Rails::Model
  property :name, :type => String
  property :address, :type => String
  property :country, :type => String
  property :description, :type => String
  property :longitude, :type => String
  property :latitude, :type => String
  property :url, :type => String

  
  has_n :networks
  has_n :documents

  has_n :companies
  has_n :contacts
  
  index :name
  index :country
  
  public
    def get_relations
	    arr = Array.new
	    self._rels.each do |a| 

	      if a[:rel_dir]=="out"
	        Rails.logger.warn "Found rel_type #{a.rel_type}"  

	        Rails.logger.warn "Found rels: #{a.props.inspect}"
	        arr << "#{a.rel_type}"
	      end

	    end
    	return arr.uniq
  	end

	def get_tree
		return "{\"text\":\"Sweden\",\"iconCls\":\"location-icon\", \"id\":2,\"cls\":\"Location\",\"leaf\":true}"
	end

end
