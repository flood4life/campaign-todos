class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to campaigns_path if current_user
  end
end