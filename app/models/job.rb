class Job < ApplicationRecord
  PARENTABLE_TYPES = {
    (ImportNf = 'ImportNf' ) => 'Realiza a importação de notas fiscais'
  }.freeze

  STATUS_JOB = {
    (PENDING = 'pending') => 'Pendente',
    (PROCESSING = 'processing') => 'Processando',
    (DONE = 'done') => 'Finalizado',
    (FAILURE = 'failure') => 'Fracassado',
  }.freeze


  belongs_to :author, class_name: 'User'
  validates :parentable_type, inclusion: { in: PARENTABLE_TYPES.keys }
end
