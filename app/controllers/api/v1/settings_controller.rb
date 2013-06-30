module Api
	module V1
		class SettingsController < ApplicationController

			respond_to	:json

			def generate_tree(root,start)
				j=ActiveSupport::JSON
				a = Array.new
				t = Hash.new
				if root
					start.each do |node|
						h = Hash.new
					    h["text"] = "#{node.name}"
					    h["iconCls"]="gear-icon"
					    h["id"]=Integer("#{node.neo_id}")
					    h["category"]="#{node.category}"
					    h["value"]="#{node.value}"
					    h["cls"]="#{node.class}"
					    h["parentID"]="NaN"
					    h["leaf"]=true

					    if t[node.category].nil? 
					    	b=Array.new
					    	b << h
					    	t[node.category] = b
					    else
					    	b = t[node.category]
					    	b << h
					    	t[node.category] = b
					    end
					end 
					t.each_key{|key| 
						h=Hash.new
					    h["text"] = "#{key}"
					    h["iconCls"]="gear-icon"
					    # h["id"]=Integer("#{node.neo_id}")
					    # h["category"]="#{node.category}"
					    # h["value"]="#{node.value}"
					    # h["cls"]="#{node.class}"
					    h["parentID"]="NaN"
					    h["leaf"]=false
					    h["children"]=t[key]
					    a << h
					}
					# a.sort!
					Rails.logger.warn(JSON.pretty_generate(a))
					return a
				end
			end

			def initialize
				if Setting.all.count == 0 
					Setting.create(:category => 'Devices', :name => 'Manage Device Types', :value => 'managedevicetypes')
					Setting.create(:category => 'Devices', :name => 'Manage Operating Systems', :value => 'manageoperatingsystems')
					Setting.create(:category => 'Devices', :name => 'Manage CPU', :value => 'managecpuparts')
					# Setting.create(:category => 'Devices', :name => 'Manage Operating Systems', :value => 'manageoperatingsystems')

					Setting.create(:category => 'Main', :name => 'SMTP Setting', :value => 'smtpSetting')
					Setting.create(:category => 'Main', :name => 'Backup/Restore', :value => 'backuprestoreconfig')
				end

			end

			def index
				Rails.logger.warn "In Configurationas"



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