module Api
	module V1
		class NetworksController < ApplicationController

		require 'ipaddr'

			respond_to	:json
			def get_device(node)
				if node.outgoing(:device).count > 0 
					return node.outgoing(:device).first				
				else
					return nil
				end
			end

			def get_ipnumbers(node)
				ipn = node.outgoing(:ipnumbers).sort_by(&:neo_id)
				if ipn.nil?
					return nil	
				else
					a = Array.new
					ipn.each {|p|
						if p.status == "Available"
							o = Hash.new
							ipaddr = IPAddress(p.ipv4)
							o["text"] = "#{ipaddr.address}"
							o["ipv4"] = "#{ipaddr.address}"
							o["netmask"]=p.netmask
							o["ipv6"]=p.ipv6
							o["id"]=p.neo_id
							o["description"]=p.description
							o["status"]=p.status
							o["id"]=p.neo_id
							o["parentID"]=node.neo_id
							o["leaf"]=true
							o["updated_at"]=p.updated_at
							o["created_at"]=p.created_at
							o["updated_by"]=p.updated_by
							o["created_by"]=p.created_by
							a<<o
						end
					}
					a.sort_by! {|ip| ip["ipv4"].split('.').map{ |octet| octet.to_i} }
					return a
				end
				
			end

			def generate_network_tree(root,start)
				j=ActiveSupport::JSON
				a = Array.new

				if root
					start.outgoing(:networks).depth(1).sort_by(&:neo_id).each do |node|
						h = Hash.new
					    h["text"] = "#{node.network_name}"
					    h["iconCls"]="network-icon"
					    h["id"]=Integer("#{node.neo_id}")
					    h["vlanid"] ="#{node.vlanid}"
					 	h["parentID"]="NaN"
					    h["cls"]="#{node.class}"
					    h["leaf"]=false
					    a << h
					end 
					# a.sort!
#					Rails.logger.warn(JSON.pretty_generate(a))
					return a
				else
					Rails.logger.warn "Creating subtree #{start.neo_id}" 
					iparr = get_ipnumbers(start)

					return iparr
				end
			end

			def get_locationid(dev)
				locid = Array.new		
				dev.both().depth(:all).each{|n| 
					if "#{n.class}" == "Location"
						Rails.logger.warn "Returning #{n.neo_id}"
						return n.neo_id 
					end 
				}
				return nil
			end

			def index
				a = Array.new

				params.each do |key,value|
					Rails.logger.warn "Param #{key}: #{value}"
				end
				if params[:node] == "NaN" && params[:whattoget].nil?

					render :json => []

				elsif params[:whattoget] == "getdevicenetworktree"	
					if params[:node] == "NaN"
						dev=Neo4j::Node.load(params[:deviceid])
						Rails.logger.warn "Getting network root tree for #{dev.to_json}"
						startid = get_locationid(dev)
						Rails.logger.warn "Getting networks for location #{startid}"

						start = Neo4j::Node.load(startid)
						root=true
					else
						start = Neo4j::Node.load(params[:node])
						Rails.logger.warn "Getting location root tree #{start.to_json} #{start.class}"
						if "#{start.class}" == "Location"
							root = true
						else
							root=false
						end
					end
					tree = generate_network_tree(root,start)
					Rails.logger.warn "Returning tree"
					Rails.logger.warn(JSON.pretty_generate(tree))
					render :json => tree
				elsif params[:action] == "index" && params[:whattoget]=="getiplist"
					node = Neo4j::Node.load(params[:networkid])
					iparr = Array.new
					start = Integer("#{params[:start]}")
					limit = Integer("#{params[:limit]}")
					count = 0
#					ips.sort_by! {|ip| ip.split('.').map{ |octet| octet.to_i} }
					
					node.outgoing(:ipnumbers).sort_by(&:neo_id).each do |ip| 
						createuser = Neo4j::Node.load(ip.created_by).email
						updateuser = Neo4j::Node.load(ip.updated_by).email

						if count >= start && count < start+limit
#	    					Rails.logger.warn "Count #{count}, start = #{start}, limit #{limit}"
							h = Hash.new
							ipaddr = IPAddress(ip.ipv4)

							h["ipv4"] = "#{ipaddr.address}"
							h["ipv6"] = "#{ip.ipv6}"
							h["parentID"] = Integer("#{node.neo_id}")
							h["iconCls"]="ipnumber-icon"
							h["id"]=Integer("#{ip.neo_id}")
							h["cls"]="#{ip.class}"
							h["status"] = "Available"
							h["description"] ="#{ip.description}"
							h["updated_at"] ="#{ip.updated_at}"
							h["updated_by"] ="#{updateuser}"
							h["created_at"] ="#{ip.created_at}"
							h["created_by"] ="#{createuser}"
							dev = get_device(ip)
							if dev != nil 
								h["devicename"]="#{dev.name}"
								h["device_id"]="#{dev.neo_id}"
								h["device_class"]="#{dev.class}"
								h["device_type"]="#{dev.devicetype}"
								h["status"]="#{dev.devicetype}"
							else
								h["devicename"]=nil
								h["device_id"]=nil
								h["device_class"]=nil
								h["device_type"]=nil
							end
							iparr << h
						end
						count += 1
						# Rails.logger.warn "Created network child #{iparr.to_json}"
					end
					if (iparr.count>0)
						c=Hash.new
						c["success"] = true
						c["totalCount"]=node.outgoing(:ipnumbers).count
						# a.sort_by {|x| x.split(/\./).map { |ip| IPAddr.new ip }.sort_by { |ip| ip.hton }
						c["ipnumbers"]=iparr.sort { |a,b| IPAddr.new( a["ipv4"] ) <=> IPAddr.new( b["ipv4"] ) } 
						# c["ipnumbers"]=iparr.sort_by {|x| x["ipv4"].split(/\./).map{ |ip| IPAddr.new ip }.sort_by { |ip| ip.hton }}
						# c["ipnumbers"]=iparr.sort_by! {|ip| ip["ipv4"].split('.').map{ |octet| octet.to_i} }
#					    Rails.logger.warn(JSON.pretty_generate(c))
						# Rails.logger.warn(JSON.pretty_generate(a))
						render :json => c
#					    a << c
						# Rails.logger.warn "IParray #{a.to_json}"
					end
				elsif params[:action]=="index" && params[:whattoget]=="generalinfo"
					node = Neo4j::Node.load(params[:networkid])
					createuser = Neo4j::Node.load(node.created_by).email
					updateuser = Neo4j::Node.load(node.updated_by).email
					h=Hash.new
					h["network_name"] = "#{node.network_name}"
					h["network"] = "#{node.network}"
					h["netmask"] = "#{node.netmask}"
					h["gateway"] = "#{node.gateway}"
					h["vlanid"] = Integer("#{node.vlanid}")
					h["iconCls"]="network-icon"
					h["id"]=Integer("#{node.neo_id}")
					h["cls"]="#{node.class}"
					h["description"] ="#{node.description}"
					h["updated_at"] ="#{node.updated_at}"
					h["updated_by"] ="#{updateuser}"
					h["created_at"] ="#{node.created_at}"
					h["created_by"] ="#{createuser}"

					a = Array.new
					a << h
					render :json => a
						
				else
					respond_with Network.all
				end
			end

			  def show
				respond_with Network.find(params[:id])
			  end

			  def create
				Rails.logger.warn "In Create network"
				resource = User.find_by_authentication_token( params[:auth_token])
				@network = Network.new("network_name"=>params[:network_name],"network"=>params[:network],"createip"=>params[:createip],"pid"=>params[:pid],"vlanid"=>params[:vlanid],"netmask"=>params[:netmask],"gateway"=>params[:gateway],"description"=>params[:description],"updated_by"=>resource.neo_id,"created_by"=>resource.neo_id)
				if @network.save
					render :json => {:success => true, :network => [@network] }
				else
					render :json => {:success => false, :message => [@network.errors], :status=>:unprocessable_entity}
				end
			  end

			  def update
				respond_with Network.update(params[:id], params[:Network])
			  end

			  def destroy
				respond_with Network.destroy(params[:id])
			  end
		end
	end
end