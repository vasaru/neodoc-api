module Api
	module V1
		class TreesController < ApplicationController

			respond_to	:json

			def index
				respond_with Location.all
			end

		end
	end
end