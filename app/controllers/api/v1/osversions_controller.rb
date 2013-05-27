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
					h["id"]=Integer(os.neo_id)
					h["cls"]="Operatingsystem"
					h["url"]=os.url
					h["vendor"]=os.productinformation
					h["status"]=os.status
					h["license"]=os.license
					h["description"]=os.description
					a << h

				end
				render :json => a
				
			end

			def show
				respond_with Operatingsystem.find(params[:id])
			end

			def create
				Rails.logger.warn "In Create network"
				resource = User.find_by_authentication_token( params[:auth_token])
				if @Operatingsystem.save
					render :json => {:success => true, :network => [@network] }
				else
					render :json => {:success => false, :message => [@Operatingsystem.errors], :status=>:unprocessable_entity}
				end
			end

			def update
				respond_with Operatingsystem.update(params[:id], params[:Network])
			end

			def destroy
				respond_with Operatingsystem.destroy(params[:id])
			end
		end
	end
end