Given(/^I have not saved any preferences$/) do
  @category_rankings = {}
  @shift_rankings = {}
  @availability = {}
end


Given(/^I have saved the following shift preferences:$/) do |rankings|
  step %Q{I have not saved any preferences}
  step %Q{I go to the set preferences page}
  fill_in_rankings rankings
  step %Q{I click "Save"}
end

Given(/^"([^"]*)" has set their preferences as:$/) do |first_name, preferences|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I fill in the following rankings:$/) do |rankings|
  fill_in_rankings rankings
end

def fill_in_rankings rankings
  categories = @current_unit.get_all_metashift_categories
  rankings.rows_hash.each do |shift, rank|
    if categories.include?(shift)
      @category_rankings[shift] = rank.to_i
      shift = "category[#{convert_to_id shift}]"
    else
      @shift_rankings[shift] = rank.to_i
      shift = "meta[#{Metashift.find_by_name(shift).id}]"
    end
    step %Q{I fill in "#{rank}" for "#{shift}"}
  end
  sleep 2
end

Given(/^I have saved the following time preferences:$/) do |availability|
  step %Q{I have not saved any preferences}
  step %Q{I go to the set preferences page}
  fill_out_availability availability
  step %Q{I click "Save"}
end

Given(/^"([^"]*)" has set the following availability:$/) do |first_name, availability|
  pending # Write code here that turns the phrase above into concrete actions
end
  
And(/^I select the following time preferences:$/) do |availability|
  fill_out_availability availability
end

def fill_out_availability availability
  set_mappings
  availability.hashes.each do |availability_hash|
    day, time_blocks, availability_status = get_availability availability_hash
    for time_block in time_blocks do
      time_block =~ /(?: )?(.*)-(.*)/
      start_time, end_time = @time_mapping[$1], @time_mapping[$2] 
      for hour in start_time..end_time do
        if not @availability[day]
          @availability[day] = {}
        end
        @availability[day][hour] = availability_status
        step %Q{I select "#{availability_status}" for "#{"avail[#{day},#{hour}]"}"}
      end
    end
  end
end

Then(/^my shift preferences should be saved$/) do
  db_preferences = {}
  @current_user.preferences.each do |preference|
    db_preferences[Metashift.find_by_id(preference.metashift_id)] = preference.get_rating
  end
  db_preferences.each do |metashift, ranking|
    # puts metashift.name
    # puts ranking
    if @shift_rankings.key?(metashift.name)
      expect(ranking).to eq(@shift_rankings[metashift.name])
    elsif @category_rankings.key?(metashift.category)
      expect(ranking).to eq(@category_rankings[metashift.category])
    else
      expect(ranking).to eq(3)
    end
  end
end

Then(/^my schedule preferences should be saved$/) do
  db_preferences = {}
  @current_user.avails.each do |a|
    if not db_preferences[a.day]
      db_preferences[a.day] = {}
    end
    db_preferences[a.day][a.hour] = a.status
  end
  db_preferences.each do |day, hour_hash|
    hour_hash.each do |hour, status|
      expect(status).to eq(@availability[day][hour])
    end
  end
end

And(/^my ranking for "([^"]*)" should be "([^"]*)"$/) do |metashift, rank|
  metashift = Metashift.find_by_name(metashift)
  expect(@current_user.preferences.where(:metashift => metashift).first.rating).to eq(rank.to_i)
end

Then(/^my availability for "([^"]*)", "([^"]*)" should be "([^"]*)"$/) do |day, hour, status|
  set_mappings
  expect(@current_user.avails.where(:day => @day_mapping[day], :hour => @time_mapping[hour]).first.status).to eq(status)
end

Then(/^I should see a(?:n)? "([^"]*)" status "([^"]*)" times$/) do |status, num|
  status_mapping = {
    "Available" => "btn-success",
    "Unavailable" => "btn-danger",
    "Not Preferred" => "btn-warning",
    "Unsure" => "btn-info"
  }
  expect(page.all(".#{status_mapping[status]}").length).to eq(num.to_i)
end

### HELPER METHODS ###
def get_availability availability_hash
  day = @day_mapping[availability_hash[:day]]
  time_blocks = availability_hash[:times].split(",")
  availability_status = availability_hash[:availability]
  return day, time_blocks, availability_status
end

def convert_to_id value
    value.gsub(/ /, "_")
end 

def set_mappings
  @day_mapping = {
    "Monday" => 0,
    "Tuesday" => 1,
    "Wednesday" => 2,
    "Thursday" => 3,
    "Friday" => 4,
    "Saturday" => 5,
    "Sunday" => 6
  }
  @time_mapping = {
    "8am" => 8,
    "9am" => 9,
    "10am" => 10,
    "11am" => 11,
    "12pm" => 12,
    "1pm" => 13,
    "2pm" => 14,
    "3pm" => 15,
    "4pm" => 16,
    "5pm" => 17,
    "6pm" => 18,
    "7pm" => 19,
    "8pm" => 20,
    "9pm" => 21,
    "10pm" => 22,
    "11pm" => 23
  }
end