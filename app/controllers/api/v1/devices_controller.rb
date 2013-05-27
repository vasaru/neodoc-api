module Api
	module V1
		class DevicesController < ApplicationController

			respond_to	:json


			def index
				params.each do |key,value|
					Rails.logger.warn "Param #{key}: #{value}"
				end
				a = Array.new
				Device.all.each do |os|
					h = Hash.new

					h["name"]=os.name
					h["id"]=Integer(os.neo_id)
					h["cls"]="Device"
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
				respond_with Device.find(params[:id])
			end

			def create
				Rails.logger.warn "In Create device params = #{params.class.name}"
				i = 0
				params.each do |key,value|
					i=i+1
					Rails.logger.warn "Param #{i} #{key}: #{value}"
				end

				resource = User.find_by_authentication_token( params[:auth_token])
				ps1 = params.first
				Rails.logger.warn "#{ps1.first}"
				params1 = ActiveSupport::JSON.decode(ps1.first)["formData1"];
				params2 = ActiveSupport::JSON.decode(ps1.first)["formData2"];

				Rails.logger.warn "params1 = #{params1}"
				Rails.logger.warn "params2 = #{params2}"

				os = Operatingsystem.find(params2["operatingsystem"])

				Rails.logger.warn "os: #{os.props.inspect}"

				pid = Neo4j::Node.load(params1["pid"]);

				Rails.logger.warn "pid: #{pid.props.inspect}"


				@device = Device.new("name"=>params[:name],"model"=>params[:deviceType],"description"=>params[:description],"updated_by"=>resource.neo_id,"created_by"=>resource.neo_id)
#				if @device.save
					render :json => {:success => true, :network => [@network] }
#				else
#					render :json => {:success => false, :message => [@Device.errors], :status=>:unprocessable_entity}
#				end
			end

			def update
				respond_with Device.update(params[:id], params[:Network])
			end

			def destroy
				respond_with Device.destroy(params[:id])
			end
		end
	end
end