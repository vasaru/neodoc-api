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
					    h["iconCls"]="customers-icon"
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
						Rails.logger.warn "Getting customer root tree"
							start = Customer.all
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
				Rails.logger.warn "In Create customer"
				# Customer.all.each{|c| c.destroy() }
				resource = User.find_by_authentication_token( params[:auth_token])
				@customer = Customer.new(
					"name"=>params[:name],
					"nickname"=>params[:nickname],
					"address"=>params[:address],
					"city"=>params[:city],
					"zip"=>params[:zip],
					"country"=>params[:country],
					"workphone1"=>params[:workphone1],
					"workphone2"=>params[:workphone2],
					"mobilephone1"=>params[:mobilephone1],
					"mobilephone2"=>params[:mobilephone2],
					"url"=>params[:url],
					"email"=>params[:email],
					"facebook"=>params[:facebook],
					"organizationnumber"=>params[:orgnumber],
					"description"=>params[:description],
					"updated_by"=>resource.neo_id,
					"created_by"=>resource.neo_id)
				if @customer.save
					render :json => {:success => true, :customer => [@customer] }
				else
					render :json => {:success => false, :message => [@customer.errors], :status=>:unprocessable_entity}
				end
			end

			def destroy
				
			end

			def show
				
			end
		end
	end
end