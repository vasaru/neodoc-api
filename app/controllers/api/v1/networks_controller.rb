module Api
	module V1
		class NetworksController < ApplicationController

			respond_to	:json
			def get_device(node)
				return nil				
			end
			def index
				a = Array.new

				params.each do |key,value|
					Rails.logger.warn "Param #{key}: #{value}"
				end
				if params[:action] == "index" && params[:whattoget]=="getiplist"
					node = Neo4j::Node.load(params[:networkid])
					iparr = Array.new
					start = Integer("#{params[:start]}")
					limit = Integer("#{params[:limit]}")
					count = 0
					node.outgoing(:ipnumbers).sort_by(&:neo_id).each do |ip| 
						createuser = Neo4j::Node.load(ip.created_by).username
						updateuser = Neo4j::Node.load(ip.updated_by).username

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
							h["status"] = "#{ip.status}"
							h["description"] ="#{ip.description}"
							h["updated_at"] ="#{ip.updated_at}"
							h["updated_by"] ="#{updateuser}"
							h["created_at"] ="#{ip.created_at}"
							h["created_by"] ="#{createuser}"
							dev = get_device(ip)
							if dev != nil 
								h["devicename"]="#{dev.hostname}"
								h["device_id"]="#{dev.neo_id}"
								h["device_class"]="#{dev.class}"
							else
								h["devicename"]=nil
								h["device_id"]=nil
								h["device_class"]=nil
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
						c["ipnumbers"]=iparr
#					    Rails.logger.warn(JSON.pretty_generate(c))
						# Rails.logger.warn(JSON.pretty_generate(a))
						render :json => c
#					    a << c
						# Rails.logger.warn "IParray #{a.to_json}"
					end
				elsif params[:action]=="index" && params[:whattoget]=="generalinfo"
					node = Neo4j::Node.load(params[:networkid])
					createuser = Neo4j::Node.load(node.created_by).username
					updateuser = Neo4j::Node.load(node.updated_by).username
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