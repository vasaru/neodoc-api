module Api
	module V1
		class TreesController < ApplicationController
			# before_filter :authenticate_user!
			respond_to	:json

			def is_leaf(node)
				if(node.both().depth(1).count>1)
					return false
				else
					return true
				end
			end

			def get_ipnumbers(node)
				ipn = node.outgoing(:ipnumbers).sort_by(&:neo_id)
				if ipn.nil?
					return nil	
				else
					a = Array.new
					ipn.each {|p|
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
					}
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
					 	h["parentID"]="NaN"
					    h["cls"]="#{node.class}"
					    h["leaf"]=is_leaf(node)
					    a << h
					end 
					# a.sort!
					Rails.logger.warn(JSON.pretty_generate(a))
					return a
				else
					Rails.logger.warn "Creating subtree #{start.neo_id}" 
					iparr = get_ipnumbers(start)

					return iparr
				end
			end


			def generate_tree(root,start)
				j=ActiveSupport::JSON
				a = Array.new
				if root
					start.each do |node|

						h = Hash.new
					    h["text"] = "#{node.name}"
					    h["iconCls"]="location-icon"
					    h["id"]=Integer("#{node.neo_id}")
					    h["cls"]="#{node.class}"
					    h["parentID"]="NaN"
					    h["leaf"]=is_leaf(node)
					    a << h
					end 
					# a.sort!
					Rails.logger.warn(JSON.pretty_generate(a))
					return a
				else
					Rails.logger.warn "Creating subtree"
					netarr = Array.new
					iparr = Array.new
					docarr = Array.new
					devarr = Array.new
					start.both().depth(1).sort_by(&:neo_id).each do |node|
						Rails.logger.warn "Found #{node.class}"
						cl = "#{node.class}"
						case cl
						when 'Network'
							h = Hash.new
						    h["text"] = "#{node.network_name}"
						    h["iconCls"]="network-icon"
						    h["id"]=Integer("#{node.neo_id}")
						 	h["parentID"]=Integer("#{start.neo_id}")
						    h["cls"]="#{node.class}"
						    h["leaf"]=true
						    netarr << h
    						Rails.logger.warn "Created network child #{netarr.to_json}"

						when 'Ipnumber'
							h = Hash.new
						    h["text"] = "#{node.ipv4}"
						    h["iconCls"]="ipnumber-icon"
						    h["id"]=Integer("#{node.neo_id}")
						    h["parentID"]=Integer("#{start.neo_id}")
						    h["cls"]="#{node.class}"
						    h["leaf"]=true
						    iparr << h
						when 'Document'
							h = Hash.new
						    h["text"] = "#{node.document_title}"
						    h["iconCls"]="document-icon"
						    h["id"]=Integer("#{node.neo_id}")
						    h["parentID"]=Integer("#{start.neo_id}")
						    h["cls"]="#{node.class}"
						    h["leaf"]=true
						    docarr << h
						end
					end
					start.both().depth(:all).filter{|path| path.end_node.rel?(:outgoing, :device)}.each{|n| 
						n.outgoing(:device).sort_by(&:name).each{|node|
							h = Hash.new
						    h["text"] = "#{node.name} (#{node.devicetype})"
						    if node.devicetype == "VM"
						    	h["iconCls"]="vm-icon"
						    else
						    	h["iconCls"]="device-icon"
						    end
						    h["id"]=Integer("#{node.neo_id}")
						    h["parentID"]=Integer("#{start.neo_id}")
						    h["parentName"]="#{start.name}"
						    h["cls"]="#{node.class}"
						    h["leaf"]=true
						    devarr << h
						}
					}


					if (netarr.count>0)
						c=Hash.new
					    c["text"] = "Networks"
					    c["iconCls"]="network-folder"
					    c["neo_id"]=Integer("#{start.neo_id}")
					    c["parentID"]=Integer("#{start.neo_id}")
					    c["parentName"]="#{start.name}"
					    c["cls"]="NetworkFolder"
					    c["expanded"]=false
					    c["children"]=netarr
					    a << c
						Rails.logger.warn "Netarray #{a.to_json}"
					end
					if (devarr.count>0)
						c=Hash.new
						@devarr = devarr.sort_by{|e| e[:text]}
					    c["text"] = "Devices"
					    c["iconCls"]="device-folder"
					    c["neo_id"]=Integer("#{start.neo_id}")
					    c["parentName"]="#{start.name}"
					    c["parentID"]=Integer("#{start.neo_id}")
					    c["cls"]="DeviceFolder"
					    c["expanded"]=false
					    c["children"]=@devarr
					    a << c
						Rails.logger.warn "Devarray #{a.to_json}"
					end

					if (iparr.count>0)
						c=Hash.new
					    c["text"] = "Ipnumbers"
					    c["iconCls"]="ipnumber-folder"
					    c["neo_id"]=Integer("#{start.neo_id}")
					    c["parentID"]=Integer("#{start.neo_id}")
					    c["parentName"]="#{start.name}"
					    c["cls"]="IpnumberFolder"
					    c["expanded"]=false
					    c["children"]=iparr
					    a << c
						Rails.logger.warn "IParray #{a.to_json}"
					end


					Rails.logger.warn(JSON.pretty_generate(a))
					return a

				end

			end

			def index

			    params.each do |key,value|
      				Rails.logger.warn "Param #{key}: #{value}"
    			end
#    			if params[:node]=="location_root"
				start=nil
				root=false
					
				if params[:whattoget] == "getdevicenetworktree"	
					if params[:node] == "NaN"
						start = Neo4j::Node.load(params[:locid])
						root=true
					else
						start = Neo4j::Node.load(params[:node])
						root=false
					end
					tree = generate_network_tree(root,start)
				else
					case params[:node]
					when 'NaN'
						Rails.logger.warn "Getting location root tree"
							start = Location.all
							root=true
					else
						Rails.logger.warn "Getting subtree for node tree #{params[:node]}"
						start = Neo4j::Node.load(params[:node])
					end

					if start!=nil
						Rails.logger.warn "Calling generate tree"
						tree = generate_tree(root,start)
					end
				end
				Rails.logger.warn "Returning tree"
				render :json => tree
			end

		end
	end
end