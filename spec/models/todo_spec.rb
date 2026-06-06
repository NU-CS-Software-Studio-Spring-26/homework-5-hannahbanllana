require "rails_helper"

RSpec.describe Todo, type: :model do
  describe ".with_category" do
    it "returns only todos in the selected category" do
      school_todo = Todo.create!(description: "Study for exam", category: "school")
      work_todo = Todo.create!(description: "Send email", category: "work")

      result = Todo.with_category("school")

      expect(result).to include(school_todo)
      expect(result).not_to include(work_todo)
    end
  end
end