class Invoice < ApplicationRecord
  belongs_to :issuing_company, class_name: 'Company'
  belongs_to :recipient_company, class_name: 'Company'
end
