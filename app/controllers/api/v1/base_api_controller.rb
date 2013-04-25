module Api
	module V1
		class BaseApiController < ApplicationController
		  respond_to :json
		end
	end
end
