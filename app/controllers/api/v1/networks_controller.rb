module Api
	module V1
		class NetworksController < ApplicationController

			respond_to	:json

			def index
				respond_with Network.all
			end

		      def show
		        respond_with Network.find(params[:id])
		      end

		      def create
		      	Rails.logger.warn "In Create network"
		      	@network = Network.new("network_name"=>params[:network_name],"network"=>params[:network],"createip"=>params[:createip],"pid"=>params[:pid],"vlanid"=>params[:vlanid],"netmask"=>params[:netmask],"gateway"=>params[:gateway],"description"=>params[:description])
		      	if @network.save
		      		render :json => {:success => true, :network => [@network] }
		      	else
		      		render :json => {:success => false, :message => [@network.errors], :status=>:unprocessable_entity}
		      	end
		      end

		      def update
		        respond_with Network.update(params[:id], params[:Network])
		      end

		      def destroy
		        respond_with Network.destroy(params[:id])
		      end
		end
	end
end