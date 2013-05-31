module Api
	module V1
		class DevicesController < ApplicationController

			respond_to	:json
			def get_parts(dev)
				
			end

			def get_ipnumbers(dev)
				
			end

			def get_ports(dev)
				
			end

			def get_company(dev)
				
			end

			def get_os(dev)
				os = dev.outgoing(:operatingsystem).first
				if os.nil?
					return Array.new
				else
					o = Hash.new
					o["name"]=os.name
					o["description"]=os.description
					o["license"]=os.license
					o["url"]=os.url
					o["status"]=os.status											
					return o
				end
			end

			def get_osversion(dev)
				osv = dev.outgoing(:osversion).first
				if osv.nil?
					return Array.new
				else
					return osv.to_array
				end
			end

			def index
				params.each do |key,value|
					Rails.logger.warn "Param #{key}: #{value}"
				end
				a = Array.new
				if params[:action] == "index" && params[:whattoget]=="getlocationdevices" then
					node = Neo4j::Node.load(params[:locationid])
					Rails.logger.warn "Location #{node.name}"

					start = Integer("#{params[:start]}")
					limit = Integer("#{params[:limit]}")
					count = 0
#					node.both().depth(:all).filter{|path| path.end_node.rel?(:outgoing, :device).each{|n| n.outgoing(:device)}.each{ 
					node.both().depth(:all).filter{|path| path.end_node.rel?(:outgoing, :device)}.each{|n| n.outgoing(:device).each{|dev|
						Rails.logger.warn "In loop"

						createuser = Neo4j::Node.load(dev.created_by).username
						updateuser = Neo4j::Node.load(dev.updated_by).username
						h = Hash.new
						h["name"]=dev.name
						Rails.logger.warn "In loop"
						h["id"]=Integer(dev.neo_id)
						Rails.logger.warn "In loop"
						h["cls"]="Device"
						Rails.logger.warn "In loop"
						h["devicetype"]=dev.devicetype
						Rails.logger.warn "In loop"
						h["model"]="#{dev.model}"
						Rails.logger.warn "In loop"
						h["serialnr"]=dev.serialnr
						Rails.logger.warn "In loop"
						h["label"]=dev.label
						Rails.logger.warn "In loop"
						h["version"]=dev.version
						Rails.logger.warn "In loop"
						h["description"]=dev.description
						Rails.logger.warn "In loop"
						h["updated_at"] ="#{dev.updated_at}"
						Rails.logger.warn "In loop"
						h["updated_by"] ="#{updateuser}"
						Rails.logger.warn "In loop"
						h["created_at"] ="#{dev.created_at}"
						Rails.logger.warn "In loop"
						h["created_by"] ="#{createuser}"
						Rails.logger.warn "In loop"
#							h["parts"]=get_parts(dev)
#							h["ipnumbers"]=get_ipnumbers(dev)
#							h["ports"]=get_ports(dev)
#							h["company"]=get_company(dev)
						h["operatingsystem"]=get_os(dev)
						Rails.logger.warn "In loop"
#						h["osversion"]=get_osversion(dev)
#						Rails.logger.warn "In loop"
						a << h

					}}
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