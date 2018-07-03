require 'rails_helper'

RSpec.describe TodoList, type: :model do
  let(:expert) { create(:expert) }
  let(:novice) { create(:novice) }
  let(:campaign_attrs) { attributes_for(:campaign) }
  let(:campaign) {
    Campaign::Create.new.(campaign_attrs.merge(user_id: expert.id)) do |t|
      t.success { |c| c }
      t.failure {}
    end
  }

  describe "Create" do
    let(:attrs) { attributes_for(:todo_list) }
    it "allows an Expert to create a TodoList" do
      list = nil
      TodoList::Create.new.(attrs.merge(user_id: expert.id, campaign_id: campaign.id)) do |t|
        t.success { |tl| list = tl }
        t.failure {}
      end
      expect(list.user).to eq(expert)
      expect(list.name).to eq(attrs[:name])
    end

    it "allows a Novice to create a TodoList" do
      list = nil
      TodoList::Create.new.(attrs.merge(user_id: novice.id, campaign_id: campaign.id)) do |t|
        t.success { |tl| list = tl }
        t.failure {}
      end
      expect(list.user).to eq(novice)
      expect(list.name).to eq(attrs[:name])
    end
  end
end
