class Job < ApplicationRecord
  has_one_attached :file

  PARENTABLE_TYPES = {
    (ImportNfJob = 'ImportNfJob' ) => 'Realiza a importação de notas fiscais'
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
