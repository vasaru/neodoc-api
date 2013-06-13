module Api
	module V1
		class DevicesController < ApplicationController

			respond_to	:json
			def get_parts(dev)
				par = dev.outgoing(:parts).sort_by(&:type)
				if par.nil?
					return nil
				else
					a = Array.new
					par.each {|p|
						o = Hash.new
						o["name"]=p.name
						o["description"]=p.description
						o["serialnr"]=p.serialnr
						o["type"]=p.type
						o["amount"]=p.amount
						o["amountmetric"]=p.amountmetric
						o["version"]=p.version
						o["company"]=get_company(p)
						o["ports"]=get_ports(p)
						o["id"]=p.neo_id
						a<<o
					}
					return a
				end
				
			end

			def get_network(ip)
				net = ip.outgoing(:network).first
				if net.nil?
					return nil	
				else
					a=Array.new
					o=Hash.new
					o["network_name"]=net.network_name
					o["vlanid"]=net.vlanid
					o["id"]=net.neo_id
					o["network"]=net.network
					o["gateway"]=net.gateway
					o["netmask"]=net.netmask
					o["description"]=net.description
					o["updated_at"]=net.updated_at
					o["created_at"]=net.created_at
					o["updated_by"]=net.updated_by
					o["created_by"]=net.created_by
					a<<o
					return o
				end
			end

			def get_ipnumbers(dev)
				ipn = dev.outgoing(:ipnumber).sort_by(&:neo_id)
				if ipn.nil?
					return nil	
				else
					a = Array.new
					ipn.each {|p|
						o = Hash.new
						ipaddr = IPAddress(p.ipv4)
						o["ipv4"] = "#{ipaddr.address}"
						o["netmask"]=p.netmask
						o["ipv6"]=p.ipv6
						o["id"]=p.neo_id
						o["description"]=p.description
						o["status"]=p.status
						o["id"]=p.neo_id
						o["updated_at"]=p.updated_at
						o["created_at"]=p.created_at
						o["updated_by"]=p.updated_by
						o["created_by"]=p.created_by
						o["network"]=get_network(p)
						a<<o
					}
					return a
				end
				
			end

			def get_ports(dev)
				port = dev.outgoing(:ports).sort_by(&:neo_id)
				if port.nil?
					return nil
				end
				
			end

			def get_company(dev)
				company = dev.outgoing(:company).first
				if company.nil?
					return nil
				else
					o = Hash.new
					o["name"]=company.name
					o["description"]=company.description
					o["license"]=company.license
					o["url"]=company.url
					o["status"]=company.status
					o["id"]=company.neo_id
					return o
				end
				
			end

			def get_os(dev)
				os = dev.outgoing(:operatingsystem).first
				if os.nil?
					return nil
				else
					o = Hash.new
					o["name"]=os.name
					o["description"]=os.description
					o["license"]=os.license
					o["url"]=os.url
					o["status"]=os.status
					o["id"]=os.neo_id
					return o
				end
			end

			def get_osversion(dev)
				osv = dev.outgoing(:osversion).first
				if osv.nil?
					return nil
				else
					o = Hash.new
					o["name"]=osv.name
					o["description"]=osv.description
					o["major"]=osv.major
					o["status"]=osv.status
					o["minor"]=osv.minor											
					o["id"]=osv.neo_id

					return o
				end
			end

			def get_iconcls(devicetype)
				case devicetype
				when "VM"
					return "virtualmachine_detailed"
					
				end
			end

			def index
				params.each do |key,value|
					Rails.logger.warn "Param #{key}: #{value}"
				end
				a = Array.new
				t = Hash.new

				if params[:action] == "getdevicenetworktree"
					# Build device network tree from #deviceID


				end

				if params[:node]
					devh = Hash.new
					node = Neo4j::Node.load(params[:node])
					node.both().depth(:all).filter{|path| path.end_node.rel?(:outgoing, :device)}.each{|n| n.outgoing(:device).each{|dev|
						createuser = Neo4j::Node.load(dev.created_by).username
						updateuser = Neo4j::Node.load(dev.updated_by).username

						h = Hash.new
						h["name"]=dev.name
						h["id"]=Integer(dev.neo_id)
						h["cls"]="Device"
						h["iconCls"]=get_iconcls(dev.devicetype)
						h["devicetype"]=dev.devicetype
						h["model"]="#{dev.model}"
						h["serialnr"]=dev.serialnr
						h["label"]=dev.label
						h["version"]=dev.version
						h["description"]=dev.description
						h["updated_at"] ="#{dev.updated_at}"
						h["updated_by"] ="#{updateuser}"
						h["created_at"] ="#{dev.created_at}"
						h["created_by"] ="#{createuser}"
						h["parts"]=get_parts(dev)
						h["ipnumbers"]=get_ipnumbers(dev)
						h["ports"]=get_ports(dev)
						h["company"]=get_company(dev)
						h["operatingsystem"]=get_os(dev)
						h["osversion"]=get_osversion(dev)
						h["leaf"]=true
						if devh[dev.devicetype] then
							j = devh[dev.devicetype]
							j["children"] << h
						else
							devh[dev.devicetype] = Hash.new
							j = devh[dev.devicetype]
							j["devicetype"]= dev.devicetype
							j["leaf"]= false
							j["children"] = Array.new 
							j["children"] << h
						end
					}}
					devh.each_key{|key| a << devh[key]}
					
					puts JSON.pretty_generate(a)
					render :json => a 
				end
				if params[:action] == "index" && params[:whattoget]=="getlocationdevices" then
					node = Neo4j::Node.load(params[:locationid])
					Rails.logger.warn "Location #{node.name}"

					start = Integer("#{params[:start]}")
					limit = Integer("#{params[:limit]}")
					count = 0
					node.both().depth(:all).filter{|path| path.end_node.rel?(:outgoing, :device)}.each{|n| n.outgoing(:device).each{|dev|
						createuser = Neo4j::Node.load(dev.created_by).email
						updateuser = Neo4j::Node.load(dev.updated_by).email
						h = Hash.new
						h["name"]=dev.name
						h["id"]=Integer(dev.neo_id)
						h["cls"]="Device"
						h["devicetype"]=dev.devicetype
						h["model"]="#{dev.model}"
						h["serialnr"]=dev.serialnr
						h["label"]=dev.label
						h["version"]=dev.version
						h["description"]=dev.description
						h["updated_at"] ="#{dev.updated_at}"
						h["updated_by"] ="#{updateuser}"
						h["created_at"] ="#{dev.created_at}"
						h["created_by"] ="#{createuser}"
						h["parts"]=get_parts(dev)
						h["ipnumbers"]=get_ipnumbers(dev)
						h["ports"]=get_ports(dev)
						h["company"]=get_company(dev)
						h["operatingsystem"]=get_os(dev)
						h["osversion"]=get_osversion(dev)
						a << h

					}}
					puts JSON.pretty_generate(a)
					render :json => a
				end

				if params[:action] == "index" && params[:whattoget]=="getdevicenetwork"
					node = Neo4j::Node.load(params[:deviceid])
					dev = Neo4j::Node.load(params[:deviceid])
					Rails.logger.warn "Device #{dev.name}"

					createuser = Neo4j::Node.load(dev.created_by).email
					updateuser = Neo4j::Node.load(dev.updated_by).email
					a = Array.new
					t = Hash.new
					a = get_ipnumbers(dev)


					puts JSON.pretty_generate(a)
					render :json => a



				end				


				if params[:action] == "index" && params[:whattoget]=="getdevice" then
					dev = Neo4j::Node.load(params[:deviceid])
					Rails.logger.warn "Device #{dev.name}"

					createuser = Neo4j::Node.load(dev.created_by).email
					updateuser = Neo4j::Node.load(dev.updated_by).email
					h = Hash.new
					h["name"]=dev.name
					h["id"]=Integer(dev.neo_id)
					h["cls"]="Device"
					h["devicetype"]=dev.devicetype
					h["model"]="#{dev.model}"
					h["serialnr"]=dev.serialnr
					h["label"]=dev.label
					h["version"]=dev.version
					h["description"]=dev.description
					h["updated_at"] ="#{dev.updated_at}"
					h["updated_by"] ="#{updateuser}"
					h["created_at"] ="#{dev.created_at}"
					h["created_by"] ="#{createuser}"
					h["parts"]=get_parts(dev)
					h["ipnumbers"]=get_ipnumbers(dev)
					h["ports"]=get_ports(dev)
					h["company"]=get_company(dev)
					h["operatingsystem"]=get_os(dev)
					h["osversion"]=get_osversion(dev)
					puts JSON.pretty_generate(a)
					render :json => h
				end

				
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
				Rails.logger.warn "Resource id = #{resource.neo_id}, email = #{resource.email}"
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
			        Neo4j::Transaction.run {
			          temprel = Neo4j::Relationship.new(:device,pid,@device)
			          temprel[:rel_name]='device'
			          temprel[:rel_dir]='out'
			          STDERR.puts("relationship added: #{temprel.props.inspect}")
			        }


#					pid.device << @device

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
				        Neo4j::Transaction.run {
				          temprel = Neo4j::Relationship.new(:parts,@device,part1)
				          temprel[:rel_name]='parts'
				          temprel[:rel_dir]='out'
				          STDERR.puts("relationship added: #{temprel.props.inspect}")
				        }
				        Neo4j::Transaction.run {
				          temprel = Neo4j::Relationship.new(:parts,@device,part2)
				          temprel[:rel_name]='parts'
				          temprel[:rel_dir]='out'
				          STDERR.puts("relationship added: #{temprel.props.inspect}")
				        }
				        Neo4j::Transaction.run {
				          temprel = Neo4j::Relationship.new(:parts,@device,part3)
				          temprel[:rel_name]='parts'
				          temprel[:rel_dir]='out'
				          STDERR.puts("relationship added: #{temprel.props.inspect}")
				        }


						# @device.parts << part1 << part2 << part3
						i = 1
						while !params2["hdd#{i}"].nil?
							Rails.logger.warn "\tAdding hdd#{i}"
							hdd = Part.new(:name => "Harddisk #{i}",:type => "HDD", :amount => params2["hdd#{i}"],:amountmetric => params2["hddmetric#{i}"])
							hdd.save
					        Neo4j::Transaction.run {
					          temprel = Neo4j::Relationship.new(:parts,@device,hdd)
					          temprel[:rel_name]='parts'
					          temprel[:rel_dir]='out'
					          STDERR.puts("relationship added: #{temprel.props.inspect}")
					        }
#							@device.parts << hdd
							i=i+1;
							
						end
					end
#					@device.operatingsystem << os
			        Neo4j::Transaction.run {
			          temprel = Neo4j::Relationship.new(:operatingsystem,@device,os)
			          temprel[:rel_name]='os'
			          temprel[:rel_dir]='out'
			          STDERR.puts("relationship added: #{temprel.props.inspect}")
			        }
#					@device.osversion << osv
			        Neo4j::Transaction.run {
			          temprel = Neo4j::Relationship.new(:osversion,@device,osv)
			          temprel[:rel_name]='osversion'
			          temprel[:rel_dir]='out'
			          STDERR.puts("relationship added: #{temprel.props.inspect}")
			        }
#					@device.ipnumber << pid
#			        Neo4j::Transaction.run {
#			          temprel = Neo4j::Relationship.new(:operatingsystem,@device,ipnumber)
#			          temprel[:rel_name]='os'
#			          temprel[:rel_dir]='out'
#			          STDERR.puts("relationship added: #{temprel.props.inspect}")
#			        }
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