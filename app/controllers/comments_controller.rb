class CommentsController < ApplicationController
  before_action :set_parent, only: %i[new create]

  def new
    @comment = @parent.comments.build
    @form = [@parent, @comment]
  end

  def create
    Comment::Create.new.(params.to_unsafe_h.merge(content: params[:comment][:content], user_id: current_user.id)) do |t|
      t.success { |c| redirect_to @parent }
      t.failure { |f| render_js_error(f) }
    end
  end

  private

  def set_parent
    @parent = if params.key?(:campaign_id)
      Campaign.find(params[:campaign_id])
    else
      TodoList.find(params[:todo_list_id])
    end
  end
end