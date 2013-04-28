module Api
	module V1
		class LocationsController < ApplicationController

			respond_to	:json


		      def create
		      	Rails.logger.debug params.inspect
		      	location = Location.new("name"=>params[:name],"country"=>params[:country],"address"=>params[:address],"description"=>params[:description],"longitude"=>params[:longitude],"latitude"=>params[:latitude])
		        if location.save
			          render :json => {:success => :true, :location => [location] }
			        else
			          render :json => {:success => :false, :message => "Failure" }
			        end
   
		      end


		end
	end
end