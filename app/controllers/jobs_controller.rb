class JobsController < ApplicationController

  def index
    @jobs = Job.all
  end

  def create
    service = Jobs::Create.call(params[:parentable_type], @current_user, params[:file_xml])
    job = service.result

    render turbo_stream: turbo_stream.replace("job-modal", partial: "jobs/modal_body", locals: { job: job })
  end

  private

  def job_params
    params.permit(:file_xml, :parentable_type)
  end
end
