class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  class Create
    include Dry::Transaction
    include TransactionHelper

    SCHEMA = Dry::Validation.Params do
      configure do
        config.messages_file = 'app/transactions/messages.yml'
      end

      required(:user_id).filled(:int?)
      required(:content).filled(:str?)
      optional(:campaign_id).maybe(:int?)
      optional(:todo_list_id).maybe(:int?)

      rule(campaign_or_todo_list_filled: %i[campaign_id todo_list_id]) do |c, tl|
        c.filled? ^ tl.filled?
      end
    end

    step :validate
    step :set_record
    step :check_permission
    step :persist

    def validate(input)
      schema_validate(SCHEMA, input)
    end

    def set_record(input)
      @record = if input.key?(:campaign_id)
        Campaign.find(input[:campaign_id])
      else
        TodoList.find(input[:todo_list_id])
      end
      Success(input)
    end

    def check_permission(input)
      if @record.is_a?(Campaign)
        Success(input)
      elsif @record.user.expert?
        Failure(:unauthorized)
      else
        Success(input)
      end
    end

    def persist(input)
      comment = @record.comments.create!(input.slice(:user_id, :content))
      Success(comment)
    rescue => e
      Failure(e)
    end
  end
end
