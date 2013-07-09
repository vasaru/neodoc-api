module Api
	module V1
		class OsversController < ApplicationController

			respond_to	:json

			def index
				params.each do |key,value|
					Rails.logger.warn "Param #{key}: #{value}"
				end
				a = Array.new
				if params[:action] == "index" && params[:whattoget]=="osversioninfo"				
						Rails.logger.warn "In Osvers"
						node = Neo4j::Node.load(params[:osid])
						node.outgoing(:osversions).sort_by(&:neo_id).each do |v|
						h = Hash.new

						h["name"]=v.name
						h["osvid"]=Integer(v.neo_id)
						h["cls"]="Osver"
#						h["isourl"]=v.isourl
						h["major"]=v.major
						h["minor"]=v.minor
#						h["build"]=v.build
#						h["patch"]=v.patch															
#						h["update"]=v.update															
#						h["downloadurl"]=v.downloadurl															
#						h["releasedate"]=v.releasedate															
#						h["patchinformation"]=v.patchinformation															
#						h["vendor"]=v.productinformation
						h["status"]=v.status
						h["description"]=v.description
						a << h

					end
					render :json => a
				else
					Osver.all.each{|v|
						h = Hash.new

						h["name"]=v.name
						h["osvid"]=Integer(v.neo_id)
						h["cls"]="Osver"
#						h["isourl"]=v.isourl
						h["major"]=v.major
						h["minor"]=v.minor
#						h["build"]=v.build
#						h["patch"]=v.patch															
#						h["update"]=v.update															
#						h["downloadurl"]=v.downloadurl															
#						h["releasedate"]=v.releasedate															
#						h["patchinformation"]=v.patchinformation															
#						h["vendor"]=v.productinformation
						h["status"]=v.status
						h["description"]=v.description
						h["_osname"]=v.incoming(:osversions).first().name
#						h["osid"]=v.incoming(:osversions).first().osid
						a << h
					}
					render :json => a
				end
			end

			def show
				respond_with Osver.find(params[:id])
			end

			def create
				Rails.logger.warn "In Create OS Version"
				resource = User.find_by_authentication_token( params[:auth_token])
				@osv = Osver.new("name"=>params[:name],"major"=>params[:major],"minor"=>params[:minor],"build"=>params[:build],"description"=>params[:description],"releasedate"=>params[:releasedate],"status"=>params[:status],"isourl"=>params[:isourl],"downloadurl"=>params[:downloadurl]) # updated_by"=>resource.neo_id,"created_by"=>resource.neo_id)
				if @osv.save
					os = Neo4j::Node.load(params[:osname])
					Neo4j::Transaction.run {
			          temprel = Neo4j::Relationship.new(:osversions,os,@osv)
			          temprel[:rel_name]='osversions'
			          temprel[:rel_dir]='out'
			          STDERR.puts("relationship added: #{temprel.props.inspect}")
			        }

					render :json => {:success => true, :Osver => [@osv] }
				else
					render :json => {:success => false, :message => [@osv.errors], :status=>:unprocessable_entity}
				end
			end

			def update
				respond_with Osver.update(params[:id], params[:Osver])
			end

			def destroy
				respond_with Osver.destroy(params[:id])
			end
		end
	end
end