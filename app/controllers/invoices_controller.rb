class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ edit update destroy ]

  # GET /invoices or /invoices.json
  def index
    group_columns = Invoice.column_names + ['companies.name', 'companies.cnpj', 'recipient_companies_invoices.name', 'recipient_companies_invoices.cnpj']
    base = Invoice.joins(:products, :issuing_company, :recipient_company)
                  .group(group_columns)
                  .select("invoices.*,
                            companies.name AS issuing_name,
                            companies.cnpj AS issuing_cnpj,
                            recipient_companies_invoices.name AS recipient_name,
                            recipient_companies_invoices.cnpj AS recipient_cnpj,
                            COUNT(products.id) AS products_quantity")
    @invoices = base
  end

  # GET /invoices/1 or /invoices/1.json
  def show
    group_columns = Invoice.column_names + ['companies.name', 'companies.cnpj', 'recipient_companies_invoices.name', 'recipient_companies_invoices.cnpj']

    base = Invoice.joins(:products, :issuing_company, :recipient_company)
                  .group(group_columns)
                  .select("invoices.*,
                            companies.name AS issuing_name,
                            companies.cnpj AS issuing_cnpj,
                            recipient_companies_invoices.name AS recipient_name,
                            recipient_companies_invoices.cnpj AS recipient_cnpj,
                            COALESCE(SUM(products.quantity_c), 0) AS total_quantity,
                            COALESCE(SUM(products.unit_price), 0) AS total_unit_price,
                            COALESCE(SUM(products.icms_price), 0) AS total_icms_price,
                            COALESCE(SUM(products.ipi_price), 0) AS total_ipi_price,
                             jsonb_agg(jsonb_build_object(
                              'name', products.name,
                              'ncm', products.ncm,
                              'cfop', products.cfop,
                              'unit_c', products.unit_c,
                              'quantity_c', products.quantity_c,
                              'unit_price', products.unit_price,
                              'icms_price', products.icms_price,
                              'ipi_price', products.ipi_price))
                              AS products_details")

    @invoice = base.find_by(id: params[:id])
  end

  # GET /invoices/new
  def new

  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
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
      params.require(:invoice).permit(:serial_number, :invoice_number, :integer, :emission_date, :issuing_company_id, :recipient_company_id)
    end
end
