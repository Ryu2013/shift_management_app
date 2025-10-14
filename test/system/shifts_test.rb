require "application_system_test_case"

class ShiftsTest < ApplicationSystemTestCase
  setup do
    @shift = shifts(:one)
  end

  test "visiting the index" do
    visit shifts_url
    assert_selector "h1", text: "Shifts"
  end

  test "should create shift" do
    visit shifts_url
    click_on "New shift"

    fill_in "Client", with: @shift.client_id
    fill_in "Date", with: @shift.date
    fill_in "Note", with: @shift.note
    fill_in "Office", with: @shift.office_id
    fill_in "Shift type", with: @shift.shift_type
    fill_in "Slots", with: @shift.slots
    click_on "Create Shift"

    assert_text "Shift was successfully created"
    click_on "Back"
  end

  test "should update Shift" do
    visit shift_url(@shift)
    click_on "Edit this shift", match: :first

    fill_in "Client", with: @shift.client_id
    fill_in "Date", with: @shift.date
    fill_in "Note", with: @shift.note
    fill_in "Office", with: @shift.office_id
    fill_in "Shift type", with: @shift.shift_type
    fill_in "Slots", with: @shift.slots
    click_on "Update Shift"

    assert_text "Shift was successfully updated"
    click_on "Back"
  end

  test "should destroy Shift" do
    visit shift_url(@shift)
    click_on "Destroy this shift", match: :first

    assert_text "Shift was successfully destroyed"
  end
end
