class ApplicationController < ActionController::Base
    before_action :config_devise_params, if: :devise_controller?
    layout :layout_by_resource
    
    # They are like private methods, but you can call them on an object & not just directly.
    protected
        def config_devise_params
            devise_parameter_sanitizer.permit(:sign_up, keys: [
            :first_name,
            :last_name,
            :username,
            :email,
            :password,
            :password_confirmation
            ])
        end
        
    # this method can never be called outside the class or explicit receiver. 
    # Any time we can call a private method inside the class or implicit receiver.
    private
        def layout_by_resource
            devise_controller? ? "session" : "application"
        end
end
