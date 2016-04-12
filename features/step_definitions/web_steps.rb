# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file was generated by Cucumber-Rails and is only here to get you a head start
# These step definitions are thin wrappers around the Capybara/Webrat API that lets you
# visit pages, interact with widgets and make assertions about page content.
#
# If you use these step definitions as basis for your features you will quickly end up
# with features that are:
#
# * Hard to maintain
# * Verbose to read
#
# A much better approach is to write your own higher level step definitions, following
# the advice in the following blog posts:
#
# * http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
# * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
# * http://elabs.se/blog/15-you-re-cuking-it-wrong
#

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within (.*[^:])$/ do |step, parent|
  with_scope(parent) { When step }
end

# Multi-line step scoper
When /^(.*) within (.*[^:]):$/ do |step, parent, table_or_string|
  with_scope(parent) { When "#{step}:", table_or_string }
end

########## PAGE NAVIGATION ##########
Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When(/^(?:|I )follow "([^"]*)"$/) do |link|
  click_link(link)
end

When(/^I follow "([^"]*)" for "([^"]*)"$/) do |arg1, arg2|
  pending 
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

########## WHAT I SHOULD SEE ON PAGE ##########
Then(/^I should see "([^"]*)" "(.+)" times$/) do |text, num|
  number = num.to_i
  page.should have_content(text, :count => number)
end


Then(/^I should see a user table$/) do
  if page.respond_to? :should
    page.should have_content("Name")
    page.should have_content("Email")
    page.should have_content("Password")
  else
    assert page.has_content?("Name")
    assert page.has_content?("Password")
    assert page.has_content?("Email")
  end
end

Then(/^I should see a workshift table$/) do
  if page.respond_to? :should
    page.should have_content("Category")
    # page.should have_content("Name")
    page.should have_content("Description")
    page.should have_content("Hour")
  else
    assert page.has_content?("Category")
    # page.should have_content("Name")
    assert page.has_content?("Description")
    assert page.has_content?("Hour")
  end
end

Then(/^(?:|I )should see "([^"]*)"$/) do |text|
  if page.respond_to? :should
    expect(page).to have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^I should see the following: (.*)$/ do |list|
  list.split(',').each do |text|
    text =~ /("(.*)")/
    step %Q{I should see #{$1}}
  end
end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end

Then(/^(?:|I )should not see "([^"]*)"$/) do |text|
  if page.respond_to? :should
    expect(page).to have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then /^I should not see the following: (.*)$/ do |list|
  list.split(',').each do |text|
    text =~ /("(.*)")/
    step %Q{I should not see #{$1}}
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath('//*', :text => regexp)
  else
    assert page.has_no_xpath?('//*', :text => regexp)
  end
end

# Checks that an element is actually present and visible, also considering styles.
# Within a selenium test, the browser is asked whether the element is really visible
# In a non-selenium test, we only check for `.hidden`, `.invisible` or `style: display:none`
#
# The step 'Then (the tag )?"..." should **not** be visible' is ambiguous. Please use 'Then (the tag )?"..." should be hidden' or 'Then I should not see "..."' instead.
#
# More details [here](https://makandracards.com/makandra/1049-capybara-check-that-a-page-element-is-hidden-via-css)
Then /^(the tag )?"([^\"]+)" should( not)? be visible$/ do |tag, selector_or_text, hidden|
  if hidden
    warn "The step 'Then ... should not be visible' is prone to misunderstandgs. Please use 'Then ... should be hidden' or 'Then I should not see ...' instead."
  end

  options = {}
  tag ? options.store(:selector, selector_or_text) : options.store(:text, selector_or_text)

  hidden ? assert_hidden(options) : assert_visible(options)
end

# Checks that an element is actually present and hidden, also considering styles.
# Within a selenium test, the browser is asked whether the element is really hidden.
# In a non-selenium test, we only check for `.hidden`, `.invisible` or `style: display:none`
Then /^(the tag )?"([^\"]+)" should be hidden$/ do |tag, selector_or_text|
  options = {}
  tag ? options.store(:selector, selector_or_text) : options.store(:text, selector_or_text)

  assert_hidden(options)
end

Then /^the following should be hidden: (.*)$/ do |list|
  list.split(',').each do |text|
    text =~ /("(.*)")/
    step %Q{#{$1} should be hidden}
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then(/^the "([^"]*)" checkbox(?: within (.*))? should be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then(/^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end

########## CLICK/SELECT/CHECK/FILL IN ##########
When(/^(?:|I )press "([^"]*)"$/) do |button|
  begin
    click_button(button)
  rescue
    click_link(button)
  end
end

When(/^(?:|I )click "([^"]*)"$/) do |button|
  begin
    click_button(button)
  rescue
    click_link(button)
  end
end

When(/^I click "([^"]*)" in the row for "([^"]*)"$/) do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end

When /^I select "([^"]*)" as the (.+) "([^"]*)"(?: date)?$/ do |date, model, selector|
  date = Date.parse(date)
  select(date.year.to_s, :from => "#{model}[#{selector}(1i)]")
  select(date.strftime("%B"), :from => "#{model}[#{selector}(2i)]")
  select(date.day.to_s, :from => "#{model}[#{selector}(3i)]")
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^(?:|I )select "([^"]*)" for "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When(/^(?:|I )check "([^"]*)"$/) do |field|
  check("ratings_"+field)
end

When(/^(?:|I )uncheck "([^"]*)"$/) do |field|
  uncheck("ratings_"+field)
end

When(/^(?:|I )choose "([^"]*)"$/) do |field|
  choose(field)
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
    fill_in(field, :with => value)
end

When /^(?:|I )fill in "([^"]*)" for "([^"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select or option
# based on naming conventions.
#
When /^(?:|I )fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
end

########## UPLOAD ##########
When(/^I upload "([^"]*)"$/) do |arg1|
  page.attach_file("file", 'lib/' + arg1)
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/ do |path, field|
  attach_file(field, File.expand_path(path))
end

########## SUBMIT ##########
Then /I submit/ do
  find('input[name="commit"]').click
end

########## ERROR ##########
Then /^the "([^"]*)" field should have the error "([^"]*)"$/ do |field, error_message|
  element = find_field(field)
  classes = element.find(:xpath, '..')[:class].split(' ')

  form_for_input = element.find(:xpath, 'ancestor::form[1]')
  using_formtastic = form_for_input[:class].include?('formtastic')
  error_class = using_formtastic ? 'error' : 'field_with_errors'

  if classes.respond_to? :should
    classes.should include(error_class)
  else
    assert classes.include?(error_class)
  end

  if page.respond_to?(:should)
    if using_formtastic
      error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
      error_paragraph.should have_content(error_message)
    else
      page.should have_content("#{field.titlecase} #{error_message}")
    end
  else
    if using_formtastic
      error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
      assert error_paragraph.has_content?(error_message)
    else
      assert page.has_content?("#{field.titlecase} #{error_message}")
    end
  end
end

Then(/^the "([^"]*)" field should have no error$/) do |field|
  element = find_field(field)
  classes = element.find(:xpath, '..')[:class].split(' ')
  if classes.respond_to? :should
    classes.should_not include('field_with_errors')
    classes.should_not include('error')
  else
    assert !classes.include?('field_with_errors')
    assert !classes.include?('error')
  end
end

########## RANDOM ##########
Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')} 
  
  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Then /^show me the page$/ do
  save_and_open_page
end