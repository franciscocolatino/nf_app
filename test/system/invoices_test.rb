require "application_system_test_case"

class InvoicesTest < ApplicationSystemTestCase
  setup do
    @invoice = invoices(:one)
  end

  test "visiting the index" do
    visit invoices_url
    assert_selector "h1", text: "Invoices"
  end

  test "should create invoice" do
    visit invoices_url
    click_on "New invoice"

    fill_in "Emission date", with: @invoice.emission_date
    fill_in "Integer", with: @invoice.integer
    fill_in "Invoice number", with: @invoice.invoice_number
    fill_in "Issuing company", with: @invoice.issuing_company_id
    fill_in "Recipient company", with: @invoice.recipient_company_id
    fill_in "Serial number", with: @invoice.serial_number
    click_on "Create Invoice"

    assert_text "Invoice was successfully created"
    click_on "Back"
  end

  test "should update Invoice" do
    visit invoice_url(@invoice)
    click_on "Edit this invoice", match: :first

    fill_in "Emission date", with: @invoice.emission_date
    fill_in "Integer", with: @invoice.integer
    fill_in "Invoice number", with: @invoice.invoice_number
    fill_in "Issuing company", with: @invoice.issuing_company_id
    fill_in "Recipient company", with: @invoice.recipient_company_id
    fill_in "Serial number", with: @invoice.serial_number
    click_on "Update Invoice"

    assert_text "Invoice was successfully updated"
    click_on "Back"
  end

  test "should destroy Invoice" do
    visit invoice_url(@invoice)
    click_on "Destroy this invoice", match: :first

    assert_text "Invoice was successfully destroyed"
  end
end
