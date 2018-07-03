novice = User.create(email: "novice@novice", password: "123456", username: "novice")
expert = User.create(email: "expert@expert", password: "123456", username: "expert", user_type: :expert, status: :qualified)

campaign = Campaign::Create.new.(title: "Camp 1", user_id: expert.id, duration: "7 days") do |t|
  t.success {|c| c}
  t.failure {|f|}
end

expert_list = TodoList::Create.new.(name: "Expert List", user_id: expert.id, campaign_id: campaign.id) do |t|
  t.success {|c| c}
  t.failure {}
end

novice_list = TodoList::Create.new.(name: "Novice List", user_id: novice.id, campaign_id: campaign.id) do |t|
  t.success {|c| c}
  t.failure {}
end

Comment::Create.new.(content: "Insightful", user_id: novice.id, todo_list_id: novice_list.id) do |t|
  t.success {|c| c}
  t.failure {}
end

Comment::Create.new.(content: "Expert opinion", user_id: expert.id, campaign_id: campaign.id) do |t|
  t.success {|c| c}
  t.failure {}
end