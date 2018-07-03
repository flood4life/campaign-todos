class CreateJoinTableCampaignsTags < ActiveRecord::Migration[5.2]
  def change
    create_join_table :campaigns, :tags
  end
end
