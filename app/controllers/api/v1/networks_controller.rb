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
		        respond_with Network.create(params[:Network])
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