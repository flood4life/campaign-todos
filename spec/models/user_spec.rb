require 'rails_helper'

RSpec.describe User, type: :model do
  let(:novice) { create(:novice) }
  let(:novice2) { create(:novice) }
  let(:expert) { create(:expert) }
  let(:expert2) { create(:expert) }
  describe "ChangeStatus" do
    it "allows an Expert to change the status of a Novice" do
      expect(novice.status).to eq(:not_qualified)
      User::ChangeStatus.new.(novice_id: novice.id, expert_id: expert.id, new_status: :qualified) do |t|
        t.success {}
        t.failure {}
      end
      novice.reload
      expect(novice.status).to eq(:qualified)
    end

    it "doesn't allow a Novice to change the status of a Novice" do
      expect(novice.status).to eq(:not_qualified)
      failure = nil
      User::ChangeStatus.new.(novice_id: novice.id, expert_id: novice2.id, new_status: :qualified) do |t|
        t.success {}
        t.failure { |f| failure = f }
      end
      novice.reload
      expect(failure).to eq(:unauthorized)
      expect(novice.status).to eq(:not_qualified)
    end

    it "doesn't allow an Expert to change the status of an Expert" do
      expect(expert.status).to eq(:qualified)
      failure = nil
      User::ChangeStatus.new.(novice_id: novice.id, expert_id: novice2.id, new_status: :banned) do |t|
        t.success {}
        t.failure { |f| failure = f }
      end
      expert.reload
      expect(failure).to eq(:unauthorized)
      expect(expert.status).to eq(:qualified)
    end

    it "allows only whitelisted statuses" do
      %i[not_qualified qualified banned].each do |valid_status|
        User::ChangeStatus.new.(novice_id: novice.id, expert_id: expert.id, new_status: valid_status) do |t|
          t.success {}
          t.failure {}
        end
        novice.reload
        expect(novice.status).to eq(valid_status)
      end
      failure = nil
      old_status = novice.status
      User::ChangeStatus.new.(novice_id: novice.id, expert_id: expert.id, new_status: :gibberish) do |t|
        t.success {}
        t.failure { |f| failure = f }
      end
      novice.reload
      expect(failure[:new_status]).to eq(["must be one of following: :not_qualified, :qualified, :banned"])
      expect(novice.status).to eq(old_status)
    end
  end
end
