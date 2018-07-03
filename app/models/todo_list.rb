class TodoList < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  has_many :comments, as: :commentable

  class Create
    include Dry::Transaction
    include TransactionHelper

    SCHEMA = Dry::Validation.Params do
      required(:user_id).filled(:int?)
      required(:campaign_id).filled(:int?)
      required(:name).filled(:str?)
    end

    step :validate
    step :persist

    def validate(input)
      schema_validate(SCHEMA, input)
    end

    def persist(input)
      list = TodoList.create!(input)
      Success(list)
    rescue => e
      Failure(e)
    end
  end
end
