module Api
	module V1
		class TreesController < ApplicationController
			before_filter :authenticate_user!
			respond_to	:json

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
					    h["leaf"]=false
					    a << h
					end 
					# a.sort!
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
				Rails.logger.warn "Getting location root tree"
				render :json => tree
			end

		end
	end
end