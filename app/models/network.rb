class Network < Neo4j::Rails::Model
  property :network_name, :type => String
  property :vlanid, :type => Fixnum
  property :network, :type => String
  property :gateway, :type => String
  property :netmask, :type => String
  property :description, :type => String
  property :updated_at, :type => DateTime
  property :created_at, :type => DateTime
  property :updated_by, :type => String
  property :created_by, :type => String
  property :createip

  property :created_at, :type => DateTime

  index :network_name, :type => :exact
  index :vlanid
  index :network
  validates :network_name, :uniqueness => true

  has_n :ipnumbers

  has_n :locations
  has_n :documents

  after_create :create_ips, :add_location
  #after_create :create_ips


  public

  def get_location
    location = self.outgoing(:location).depth(1).first()
    return location
  end

  def get_ipnumbers
    ipnumbers = self.outgoing(:ipnumbers).depth(1)
    return ipnumbers
  end

  def get_documents
    documents = self.outgoing(:document).depth(1)
    return documents
  end

  def get_devices
    devices = self.outgoing(:ipnumbers).outgoing(:devices).outgoing(:servers).depth(2)
    return devices
  end

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

  def create_ips
    Rails.logger.warn "In Create IPs"
    # if(createip="on") 
      tmp = network+'/'+netmask;
      gw=IPAddress(gateway+"/"+netmask);
      ipaddr = IPAddress(tmp)
      ipaddr.each_host do |addr|
        STDERR.puts("addr: #{addr.to_string}")
        # STDERR.puts("addr: #{addr}")
        #                        temp=Ipnumber.new(:ipv4 => addr.to_string, :netmask => addr.netmask)
        temp = Ipnumber.new
        temp.ipv4 = addr.to_string
        temp.netmask = addr.netmask
        temp.updated_by = updated_by
        temp.created_by = created_by
        if(addr == gw)
          Rails.logger.warn "Created GW"
          temp.status = "Gateway"
        else
          temp.status = "Available"
        end
        temp.valid?
        temp.save

        self.ipnumbers << temp
        temp.network << self

        self.save
        temp.save

        
        # STDERR.puts("added addr: #{temp.props.inspect}")

        # Neo4j::Transaction.run {
        #   temprel = Neo4j::Relationship.new(:ipnumbers,self,temp)
        #   temprel[:rel_name]='Ipnumber'
        #   temprel[:rel_dir]='out'
        #   STDERR.puts("relationship added: #{self.props.inspect}")
        # }

        # Neo4j::Transaction.run {
        #   temprel = Neo4j::Relationship.new(:network,temp,self)
        #   temprel[:rel_name]='Network'
        #   temprel[:rel_dir]='in'
        #   STDERR.puts("relationship added: #{self.props.inspect}")
        # }


      end
  # end
  end

  def add_location
    if !pid.nil?
      STDERR.puts("Location_id: #{pid}, self=")

      temp = Neo4j::Node.load(pid)
      # self.locations << temp
      temp.networks << self
      temp.save
      #self.save

#      Neo4j::Transaction.run {
#        temprel = Neo4j::Relationship.new(:location,self,temp)
#        temprel[:rel_name]='Location'
#        temprel[:rel_dir]='in'
#        STDERR.puts("relationship added: #{temprel.props.inspect}")
#        temprel2 = Neo4j::Relationship.new(:network,temp,self)
#        temprel2[:rel_name]='Network'
#        temprel2[:rel_dir]='out'
#        STDERR.puts("relationship added: #{temprel2.props.inspect}")
#      }

    end
  end
end
