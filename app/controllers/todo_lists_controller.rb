class TodoListsController < ApplicationController
  def new
    @campaign = Campaign.find(params[:campaign_id])
    @list = @campaign.todo_lists.build
    @form = [@campaign, @list]
  end

  def show
    @list = TodoList.find(params[:id])
  end

  def create
    TodoList::Create.new.(params.to_unsafe_h.merge(params[:todo_list].to_unsafe_h).merge( user_id: current_user.id)) do |t|
      t.success { |c| redirect_to todo_list_path(c) }
      t.failure { |f| render_js_error(f) }
    end
  end
end