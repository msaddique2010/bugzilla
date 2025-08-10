require "application_system_test_case"

class BugsTest < ApplicationSystemTestCase
  setup do
    @bug = bugs(:one)
  end

  test "visiting the index" do
    visit bugs_url
    assert_selector "h1", text: "Bugs"
  end

  test "should create bug" do
    visit bugs_url
    click_on "New bug"

    fill_in "Description", with: @bug.description
    fill_in "Priotity", with: @bug.priotity
    fill_in "Title", with: @bug.title
    click_on "Create Bug"

    assert_text "Bug was successfully created"
    click_on "Back"
  end

  test "should update Bug" do
    visit bug_url(@bug)
    click_on "Edit this bug", match: :first

    fill_in "Description", with: @bug.description
    fill_in "Priotity", with: @bug.priotity
    fill_in "Title", with: @bug.title
    click_on "Update Bug"

    assert_text "Bug was successfully updated"
    click_on "Back"
  end

  test "should destroy Bug" do
    visit bug_url(@bug)
    click_on "Destroy this bug", match: :first

    assert_text "Bug was successfully destroyed"
  end
end
