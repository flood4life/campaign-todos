class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end

  def new
    @campaign = Campaign.new
  end

  def show
    @campaign = Campaign.find(params[:id])
  end

  def create
    Campaign::Create.new.(params.to_unsafe_h.merge(params[:campaign].to_unsafe_h).merge(user_id: current_user.id)) do |t|
      t.success { |c| redirect_to campaign_path(c) }
      t.failure { |f| render_js_error(f) }
    end
  end
end