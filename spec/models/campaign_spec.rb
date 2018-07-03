require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let(:novice) { create(:novice) }
  let(:expert) { create(:expert) }
  let(:attrs) { attributes_for(:campaign) }
  describe "Create" do
    it "allows an Expert to create a Campaign" do
      campaign = nil
      Campaign::Create.new.(attrs.merge(user_id: expert.id)) do |t|
        t.success { |c| campaign = c }
        t.failure {}
      end
      expect(campaign.user).to eq(expert)
      expect(campaign.duration).to eq(attrs[:duration])
      expect(campaign.title).to eq(attrs[:title])
    end

    it "doesn't allow a Novice to create a Campaign" do
      failure = nil
      expect {
        Campaign::Create.new.(attrs.merge(user_id: novice.id)) do |t|
          t.success {}
          t.failure { |f| failure = f }
        end
      }.to change { Campaign.count }.by(0)
      expect(failure).to eq(:unauthorized)
    end
  end
end
