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

				osv = Neo4j::Node.load(params2["version"]);

				Rails.logger.warn "osv: #{osv.props.inspect}"

				pid = Neo4j::Node.load(Integer(params1["pid"]));

				Rails.logger.warn "pid: #{pid.props.inspect}"

				Rails.logger.warn "#{params1["deviceType"]}"

				@device = Device.new("name"=>params1["name"],"model"=>params1["device.model"],
					"devicetype"=>params1["deviceType"],"serialnr"=>params1["device.serialnr"],
					"description"=>params2["description"],"updated_by"=>resource.neo_id,
					"created_by"=>resource.neo_id)

				Rails.logger.warn "After Device.new"


				if @device.save
					Rails.logger.warn "After device.save"
					pid.device << @device
					pid.status = params1["deviceType"]
					pid.updated_by = resource.neo_id
					pid.save
					Rails.logger.warn "After pid.save, creating parts \"#{params1["deviceType"]}\""
					if ( params1["deviceType"]=="VM")
						Rails.logger.warn "Adding parts"
						part1 = Part.new(:name => "Memory",:type => "vMem", :amount => params2["memory"], :amountmetric => params2["memmetric"])
						part1.save
						part2 = Part.new(:name => "CPU",:type => "vCPU", :amount => params2["cpu"])
						part2.save
						part3 = Part.new(:name => "Cores",:type => "vCores", :amount => params2["cores"])
						part3.save
						@device.parts << part1 << part2 << part3
						i = 1
						while !params2["hdd#{i}"].nil?
							Rails.logger.warn "\tAdding hdd#{i}"
							hdd = Part.new(:name => "Harddisk #{i}",:type => "HDD", :amount => params2["hdd#{i}"],:amountmetric => params2["hddmetric#{i}"])
							hdd.save
							@device.parts << hdd
							i=i+1;
							
						end
					end
					@device.operatingsystem << os
					@device.osversion << osv
					@device.ipnumber << pid
					@device.save
					Rails.logger.warn "Added device id #{@device.neo_id}"


					render :json => {:success => true, :network => [@device] }
				else
					render :json => {:success => false, :message => [@device.errors], :status=>:unprocessable_entity}
				end
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