module Api
  module V1
    class SessionsController < BaseApiController
      before_filter :authenticate_user!, :except => [:create, :destroy ]
      before_filter :ensure_params_exist, :except => [:say_hi, :destroy, :verify]
      respond_to :json
     
      def create
        resource = User.find_for_database_authentication(:email => params[:user_login][:email])
        return invalid_login_attempt unless resource
     
        if resource.valid_password?(params[:user_login][:password])
          sign_in(:user, resource)
          resource.ensure_authentication_token!
          render :json=> {:success=>true, 
                          :auth_token=>resource.authentication_token, 
                          :email=>resource.email
#                          :sign_in_count=>resource.sign_in_count,
#                          :current_sign_in_ip=>resource.current_sign_in_ip,
#                          :username=>resource.username

#                          :role => resource.role.to_json
                  }
          return
        end
        invalid_login_attempt
      end
      
      def verify
        resource = User.find_by_authentication_token( params[:auth_token])
        if resource
          render :json=> {:success=>true}
        else
          render :json=> {:success=>false}
        end
      end

      def say_hi
        render :json=> {:success=>true, 
                        :msg => "Server: This is your coffee!"
                }
      end
     
      def destroy
        # resource = User.find_for_database_authentication(:email => params[:user_login][:email])
        resource = User.find_by_authentication_token( params[:auth_token])
        resource.authentication_token = nil
        # resource.save
        
        if resource and resource.save
          render :json=> {:success=>true}
        else
          render :json=> {:success=>false}
        end
        
      end
     
      protected
      def ensure_params_exist
        return unless params[:user_login].blank?
        render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
      end
     
      def invalid_login_attempt
        render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
      end
    end
  end
end
