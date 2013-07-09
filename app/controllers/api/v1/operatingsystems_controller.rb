module Api
	module V1
		class OperatingsystemsController < ApplicationController

			respond_to	:json


			def index
				params.each do |key,value|
					Rails.logger.warn "Param #{key}: #{value}"
				end
				a = Array.new
				Operatingsystem.all.each do |os|
					h = Hash.new

					h["name"]=os.name
					h["osid"]=Integer(os.neo_id)
					h["cls"]="Operatingsystem"
					h["url"]=os.url
					h["vendor"]=os.productinformation
					h["status"]=os.status
					h["license"]=os.license
					h["description"]=os.description
					h["updated_at"] ="#{os.updated_at}"
#					h["updated_by"] ="#{updateuser}"
					h["created_at"] ="#{os.created_at}"
#					h["created_by"] ="#{createuser}"
					a << h

				end
				render :json => a
				
			end

			def show
				respond_with Operatingsystem.find(params[:id])
			end

			def create
				Rails.logger.warn "In Create Operatingsystem"
				params.each do |key,value|
					Rails.logger.warn "Param #{key}: #{value}"
				end

				resource = User.find_by_authentication_token( params[:auth_token])
				@Operatingsystem = Operatingsystem.new("name"=>params[:name],"productinformation"=>params[:vendor],"url"=>params[:url],"status"=>params[:status],"description"=>params[:description]) # updated_by"=>resource.neo_id,"created_by"=>resource.neo_id)
				if @Operatingsystem.save
					render :json => {:success => true, :operatingsystem => [@Operatingsystem] }
				else
					render :json => {:success => false, :message => [@Operatingsystem.errors], :status=>:unprocessable_entity}
				end
			end

			def update
				respond_with Operatingsystem.update(params[:id], params[:Network])
			end

			def destroy
				Rails.logger.warn "In Destroy Operatingsystem"
				params.each do |key,value|
					Rails.logger.warn "Param #{key}: #{value}"
				end
				node = Neo4j::Node.load(params[:osid])
				respond_with node.destroy()
			end
		end
	end
end