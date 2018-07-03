class Campaign < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :comments, as: :commentable
  has_many :todo_lists

  class Create 
    include Dry::Transaction
    include TransactionHelper

    SCHEMA = Dry::Validation.Params do
      required(:user_id).filled(:int?)
      required(:title).filled(:str?)
      required(:duration).filled
    end

    step :validate
    step :check_permission
    step :persist

    def validate(input)
      schema_validate(SCHEMA, input)
    end

    def check_permission(input)
      if User.find(input[:user_id]).expert?
        Success(input)
      else
        Failure(:unauthorized)
      end
    end

    def persist(input)
      campaign = Campaign.create!(input)
      Success(campaign)
    rescue => e
      Failure(e)
    end
  end
end
