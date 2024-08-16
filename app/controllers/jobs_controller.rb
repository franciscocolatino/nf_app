class JobsController < ApplicationController

  def index
    @jobs = Job.all
  end

  def create
    file = params[:file_xml].tempfile.path
    job = Jobs::Create.call(params[:parentable_type], current_user, { file_path: file })

    job
  end

  private

  def job_params
    params.permit(:file_xml, :parentable_type)
  end
end
