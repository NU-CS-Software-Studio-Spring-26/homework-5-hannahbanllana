Given("I am a user on the todos index page") do
    visit todos_path
  end
  
  When("I filter by category {string}") do |category|
    select category, from: "category"
    click_button "Filter"
  end
  
  Then("I should see todos tagged {string}") do |category|
    expect(page).to have_css(".todo-category", text: category)
  end
  
  When("I filter by a category that does not exist") do
    select "not a category", from: "category"
    click_button "Filter"
  end
  
  Then("I should not see any todos") do
    expect(page).not_to have_css(".todo-item")
  end