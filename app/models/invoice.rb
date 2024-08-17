class Invoice < ApplicationRecord
  belongs_to :issuing_company, class_name: 'Company', foreign_key: 'issuing_company_id'
  belongs_to :recipient_company, class_name: 'Company', foreign_key: 'recipient_company_id'
end
