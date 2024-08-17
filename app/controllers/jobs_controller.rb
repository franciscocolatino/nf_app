class JobsController < ApplicationController

  def index
    @jobs = Job.all
  end

  def create
    
    @job = Jobs::Create.call(params[:parentable_type], @current_user, params[:file_xml])
  end

  private

  def job_params
    params.permit(:file_xml, :parentable_type)
  end
end
