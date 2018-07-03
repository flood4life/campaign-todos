require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:expert) { create(:expert) }
  let(:novice) { create(:novice) }
  let(:campaign_attrs) { attributes_for(:campaign) }
  let(:campaign) {
    Campaign::Create.new.(campaign_attrs.merge(user_id: expert.id)) do |t|
      t.success { |c| c }
      t.failure {}
    end
  }
  let(:todo_attrs) { attributes_for(:todo_list) }
  let(:expert_todo_list) {
    TodoList::Create.new.(todo_attrs.merge(user_id: expert.id, campaign_id: campaign.id)) do |t|
      t.success { |tl| tl }
      t.failure {}
    end
  }
  let(:novice_todo_list) {
    TodoList::Create.new.(todo_attrs.merge(user_id: novice.id, campaign_id: campaign.id)) do |t|
      t.success { |tl| tl }
      t.failure {}
    end
  }
  describe "Create" do
    let(:attrs) { attributes_for(:comment) }
    it "allows all users to comment on Campaigns" do
      expect {
        Comment::Create.new.(attrs.merge(user_id: novice.id, campaign_id: campaign.id)) do |t|
          t.success {}
          t.failure {}
        end
        Comment::Create.new.(attrs.merge(user_id: expert.id, campaign_id: campaign.id)) do |t|
          t.success {}
          t.failure {}
        end
      }.to change { campaign.comments.count }.by(2)
    end

    it "allows all users to comment on Novice TodoLists" do
      expect {
        Comment::Create.new.(attrs.merge(user_id: novice.id, todo_list_id: novice_todo_list.id)) do |t|
          t.success {}
          t.failure {}
        end
        Comment::Create.new.(attrs.merge(user_id: expert.id, todo_list_id: novice_todo_list.id)) do |t|
          t.success {}
          t.failure {}
        end
      }.to change { novice_todo_list.comments.count }.by(2)
    end

    it "doesn't allow any users to comment on Expert TodoLists" do
      expect {
        failure = nil
        Comment::Create.new.(attrs.merge(user_id: novice.id, todo_list_id: expert_todo_list.id)) do |t|
          t.success {}
          t.failure { |f| failure = f }
        end
        expect(failure).to eq(:unauthorized)

        failure = nil
        Comment::Create.new.(attrs.merge(user_id: expert.id, todo_list_id: expert_todo_list.id)) do |t|
          t.success {}
          t.failure { |f| failure = f }
        end
        expect(failure).to eq(:unauthorized)
      }.to change { expert_todo_list.comments.count }.by(0)
    end
  end
end
