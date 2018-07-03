class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    User::ChangeStatus.new.(expert_id: current_user.id, novice_id: params[:id], new_status: params[:user][:status]) do |t|
      t.success { |c| redirect_to campaign_path(c) }
      t.failure { |f| render_js_error(f) }
    end
  end
end