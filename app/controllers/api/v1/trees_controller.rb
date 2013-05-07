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

					start.both().depth(1).sort_by(&:neo_id).each do |node|
						Rails.logger.warn "Found #{node.class}"
						cl = "#{node.class}"
						case cl
						when 'Network'
							h = Hash.new
						    h["text"] = "#{node.network_name}"
						    h["iconCls"]="network-icon"
						    h["id"]=Integer("#{node.neo_id}")
						    h["cls"]="#{node.class}"
						    h["leaf"]=is_leaf(node)
						    netarr << h
    						Rails.logger.warn "Created network child #{netarr.to_json}"

						when 'Ipnumber'
							h = Hash.new
						    h["text"] = "#{node.ipv4}"
						    h["iconCls"]="ipnumber-icon"
						    h["id"]=Integer("#{node.neo_id}")
						    h["cls"]="#{node.class}"
						    h["leaf"]=true
						    iparr << h
						when 'Document'
							h = Hash.new
						    h["text"] = "#{node.document_title}"
						    h["iconCls"]="document-icon"
						    h["id"]=Integer("#{node.neo_id}")
						    h["cls"]="#{node.class}"
						    h["leaf"]=true
						    docarr << h
						end
					end
					if (netarr.count>0)
						c=Hash.new
					    c["text"] = "Networks"
					    c["iconCls"]="network-folder"
					    c["neo_id"]=Integer("#{start.neo_id}")
					    c["cls"]="NetworkFolder"
					    c["expanded"]=false
					    c["children"]=netarr
					    a << c
						Rails.logger.warn "Netarray #{a.to_json}"
					end
					if (iparr.count>0)
						c=Hash.new
					    c["text"] = "Ipnumbers"
					    c["iconCls"]="ipnumber-folder"
					    c["neo_id"]=Integer("#{start.neo_id}")
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
				start = nil
				root=false
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
				Rails.logger.warn "Returning tree: #{tree}"
				render :json => tree
			end

		end
	end
end