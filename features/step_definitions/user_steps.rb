# Add a declarative step here for populating the DB with movies.

Given /the following users exist/ do |users_table|
  # puts users_table
  users_table.hashes.each do |user|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that user to the database here.
    User.create!(user)
  end
  # puts "COUNT: " + User.all.count.to_s
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  (page.body =~Regexp.new(e1)).should < (page.body =~Regexp.new(e2))
end


Then(/^I should have admin rights$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"


When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if uncheck
    rating_list.split(", ").each do |rating|
      uncheck("ratings_"+rating)
    end
  else
    rating_list.split(", ").each do |rating|
      check("ratings_"+rating)
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  page.all('table#movies tbody tr').count.should == 4
end


Then(/^the director of "(.*?)" should be "(.*?)"$/) do |arg1, arg2|
  (page.body =~ Regexp.new(arg1)).should >= 0 
end