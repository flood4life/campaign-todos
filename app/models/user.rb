class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def user_type
    super.to_sym
  end

  def status
    super.to_sym
  end

  def novice?
    user_type == :novice
  end

  def expert?
    user_type == :expert
  end

  class ChangeStatus 
    include Dry::Transaction
    include TransactionHelper

    SCHEMA = Dry::Validation.Params do
      configure do
        config.messages_file = 'app/transactions/messages.yml'

        def valid_status?(value)
          %i[not_qualified qualified banned].include?(value.to_sym)
        end
      end

      required(:novice_id).filled(:int?)
      required(:expert_id).filled(:int?)
      required(:new_status).filled(:valid_status?)
    end

    step :validate
    step :check_permission
    step :persist

    def validate(input)
      schema_validate(SCHEMA, input)
    end

    def check_permission(input)
      if User.find(input[:novice_id]).novice? && User.find(input[:expert_id]).expert?
        Success(input)
      else
        Failure(:unauthorized)
      end
    end

    def persist(input)
      user = User.find(input[:novice_id])
      user.update_attributes! status: input[:new_status]
      Success(user)
    rescue => e
      Failure(e)
    end
  end
end
