class Invoices::IndexQuery
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
    subquery = Invoice.joins(:products, :issuing_company, :recipient_company)
                      .group(get_group_columns)
                      .select("invoices.*,
                                companies.name AS issuing_name,
                                companies.cnpj AS issuing_cnpj,
                                recipient_companies_invoices.name AS recipient_name,
                                recipient_companies_invoices.cnpj AS recipient_cnpj,
                                COUNT(products.id) AS products_quantity")
    base = Invoice.unscoped.from(subquery, :invoices)
    
    base = base.where(search) if @params[:search]
    base = base.select("invoices.*")
    base = base.order("invoices.created_at DESC")
    base
  end

  def search
    "lower(trim(invoices.invoice_number::text)) ILIKE lower(trim('%#{@params[:search]}%')) OR
    lower(trim(issuing_name::text)) ILIKE lower(trim('%#{@params[:search]}%')) OR
    lower(trim(recipient_name::text)) ILIKE lower(trim('%#{@params[:search]}%')) OR
    lower(trim(issuing_cnpj::text)) ILIKE lower(trim('%#{@params[:search]}%')) OR
    lower(trim(recipient_cnpj::text)) ILIKE lower(trim('%#{@params[:search]}%'))"
  end

  def get_group_columns
    Invoice.column_names + ['companies.name', 'companies.cnpj', 'recipient_companies_invoices.name', 'recipient_companies_invoices.cnpj']
  end
end
