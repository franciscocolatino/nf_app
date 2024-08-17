class ImportNfJob < ApplicationJob
  queue_as :default

  def perform(job_id, current_user_id, arguments)
    Imports::ProcessFile.call(job_id, current_user_id, arguments)
  end
end
