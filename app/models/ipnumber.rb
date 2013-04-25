class Ipnumber < Neo4j::Rails::Model
  property :ipv4, :type => String
  property :ipv6, :type => String
  property :netmask, :type => String
  property :status, :type => String
  property :description, :type => String

  has_n :network

  has_n :device

  index :ipv4, :type => :exact
  #validates :ipv4, :uniqueness => true

#  after_create :debugmsg

  public
  def get_network
    network = self.outgoing(:network).depth(1).first()
    return network
  end

  def debugmsg
    STDERR.puts("created IP: #{self[:ipv4]}")
  end
end
