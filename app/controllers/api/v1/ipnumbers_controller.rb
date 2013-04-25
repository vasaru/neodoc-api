module Api
	module V1
		class IpnumbersController < ApplicationController

			respond_to	:json

			def index
				respond_with Ipnumber.all
			end

		      def show
		        respond_with Ipnumber.find(params[:id])
		      end

		      def create
		        respond_with Ipnumber.create(params[:Ipnumber])
		      end

		      def update
		        respond_with Ipnumber.update(params[:id], params[:Ipnumber])
		      end

		      def destroy
		        respond_with Ipnumber.destroy(params[:id])
		      end
		end
	end
end