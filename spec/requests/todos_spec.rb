require "rails_helper"

RSpec.describe "Todos index filtering", type: :request do
  it "filters todos by category param" do
    school_todo = Todo.create!(description: "Study for exam", category: "school")
    work_todo = Todo.create!(description: "Send email", category: "work")

    get todos_path, params: { category: "school" }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Study for exam")
    expect(response.body).not_to include("Send email")
  end
end