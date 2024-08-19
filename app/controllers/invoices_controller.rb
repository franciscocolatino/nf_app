class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ edit update destroy ]

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoices::IndexQuery.call(params).result

    @invoices
  end

  # GET /invoices/1 or /invoices/1.json
  def show
    @invoice = Invoices::ShowQuery.call(params).result

    @invoice
  end

  # GET /invoices/new
  def new

  end

  # GET /invoices/1/edit
  def edit
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice)
            .permit(:serial_number, :invoice_number, :integer,
                    :emission_date, :issuing_company_id,
                    :recipient_company_id, :search)
    end
end
