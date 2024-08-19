class Invoices::ShowQuery
  prepend SimpleCommand

  def initialize(params)
    @params = params || {}
  end

  def call
    query
  rescue => e
    errors.add(:index_query, e.to_s)
  end

  def query
    base = Invoice.joins(:products, :issuing_company, :recipient_company)
                  .group(get_group_columns)
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
    base = base.find_by(id: @params[:id])

    base
  end

  def get_group_columns
    Invoice.column_names + ['companies.name', 'companies.cnpj', 'recipient_companies_invoices.name', 'recipient_companies_invoices.cnpj']
  end
end
