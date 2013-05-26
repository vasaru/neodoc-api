class Document < Neo4j::Rails::Model
  property :title, :type => String
  property :type, :type => String
  property :date, :type => DateTime
  property :description, :type => String
  property :data, :type => String
  property :path, :type => String
  property :version, :type => String
  property :owner, :type => String
  property :updated_by, :type => String
  property :created_by, :type => String
  property :pid

  has_n(:network).to(Network)
  has_n :location
  has_n :server
  has_n :ipnumber

  index :title
  index :type
  

  after_create :add_parent


  public
  def get_location
    location = self.outgoing(:location).depth(1).first()
    return location
  end

  def get_id (data)
  	# STDERR.puts("parent_id: #{data.inspect}")
  	data.each_pair do |key, value|
  		if key.to_s.match('.*_id') 
  			pid = value
  			return value
  		end
  	end

  end

  private




  def add_parent
    STDERR.puts("Adding parent, parent_id: #{pid}")

    temp = Neo4j::Node.load(pid)
    parent_class = temp.class.to_s
	  STDERR.puts("Parent class: #{parent_class}")
    case parent_class
    when 'Location'
	    Neo4j::Transaction.run {
	      temprel = Neo4j::Relationship.new(:location,self,temp)
	      temprel[:rel_name]='Location'
	      temprel[:rel_dir]='in'
	      STDERR.puts("relationship added: #{temprel.props.inspect}")
	      temprel2 = Neo4j::Relationship.new(:document,temp,self)
	      temprel2[:rel_name]='Document'
	      temprel2[:rel_dir]='out'
	      STDERR.puts("relationship added: #{temprel2.props.inspect}")
	    }
    when 'Network'
    	STDERR.puts("Adding Network relationships")
    	self.network << temp
    	temp.document << self
    	self.save
    	temp.save
    	STDERR.puts("#{self.rels.inspect}")

	    Neo4j::Transaction.run {
	      temprel = Neo4j::Relationship.new(:network,self,temp)
	      temprel[:rel_name]='Network'
	      temprel[:rel_dir]='in'
	      STDERR.puts("relationship added: #{temprel.props.inspect}")
	      temprel2 = Neo4j::Relationship.new(:document,temp,self)
	      temprel2[:rel_name]='Document'
	      temprel2[:rel_dir]='out'
	      STDERR.puts("relationship added: #{temprel2.props.inspect}")
	    }
    when 'Server'
	    Neo4j::Transaction.run {
	      temprel = Neo4j::Relationship.new(:server,self,temp)
	      temprel[:rel_name]='Server'
	      temprel[:rel_dir]='in'
	      STDERR.puts("relationship added: #{temprel.props.inspect}")
	      temprel2 = Neo4j::Relationship.new(:document,temp,self)
	      temprel2[:rel_name]='Document'
	      temprel2[:rel_dir]='out'
	      STDERR.puts("relationship added: #{temprel2.props.inspect}")
	    }
    when 'Ipnumber'
	    Neo4j::Transaction.run {
	      temprel = Neo4j::Relationship.new(:ipnumber,self,temp)
	      temprel[:rel_name]='Ipnumber'
	      temprel[:rel_dir]='in'
	      STDERR.puts("relationship added: #{temprel.props.inspect}")
	      temprel2 = Neo4j::Relationship.new(:document,temp,self)
	      temprel2[:rel_name]='Document'
	      temprel2[:rel_dir]='out'
	      STDERR.puts("relationship added: #{temprel2.props.inspect}")
	    }


    	
    end

  end
end
