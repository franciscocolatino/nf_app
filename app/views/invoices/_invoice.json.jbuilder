json.extract! invoice, :id, :serial_number, :invoice_number, :integer, :emission_date, :issuing_company_id, :recipient_company_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
