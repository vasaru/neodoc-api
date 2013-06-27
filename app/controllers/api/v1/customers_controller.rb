module Api
	module V1
		class CustomersController < ApplicationController

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
					    h["category"]="#{node.category}"
					    h["cls"]="#{node.class}"
					    h["parentID"]="NaN"
					    h["leaf"]=true
					    a << h
					end 
					# a.sort!
					Rails.logger.warn(JSON.pretty_generate(a))
					return a
				end
			end

			def index
				case params[:node]
					when 'NaN'
						Rails.logger.warn "Getting location root tree"
							start = Setting.all
							root=true
				else
					Rails.logger.warn "Getting subtree for node tree #{params[:node]}"
						start = Neo4j::Node.load(params[:node])
				end

				if start!=nil
					Rails.logger.warn "Calling generate tree"
					tree = generate_tree(root,start)
				end
			
				Rails.logger.warn "Returning tree"
				render :json => tree
			end

			def update

			end

			def create
				
			end

			def destroy
				
			end

			def show
				
			end
		end
	end
end