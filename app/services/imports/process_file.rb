class Imports::ProcessFile
  prepend SimpleCommand

  def initialize(job_id, current_user_id, arguments)
    @job = Job.find(job_id)
    @current_user = User.find(current_user_id)
    @arguments = arguments
  rescue => e
    error_handling(:initialize_process_file, e.to_s)
  end

  def call
    @job.update_columns(status: Job::PROCESSING, progress: 50)

    file = Nokogiri::XML(@job.file.download)

    invoice = process_data(file)

    if errors.full_messages.empty?
      @job.update_columns(status: Job::DONE, progress: 100, content: { invoice_id: invoice.id })
    else
      update_error_job(errors.full_messages.join(', '))
    end
  end

  def process_data(file)
    file = file.css('infNFe')
    emit_infos = file.css('emit')
    dest_infos = file.css('dest')
    nfe_infos = file.css('ide')

    ActiveRecord::Base.transaction do
      company_emit = create_company(emit_infos)
      company_dest = create_company(dest_infos)
      
      invoice = create_invoice(nfe_infos, company_emit, company_dest)

      process_products(file, invoice)

      invoice
    end
  rescue => e
    errors.add(:process_data, e.to_s)
  end

  def process_products(file, invoice)
    products_file = file.css('det')

    products_instances = products_file.map do |product_file|
      instance_product(product_file, invoice.id)
    end

    Product.import(products_instances, batch_size: 1000)
  rescue => e
    errors.add(:process_products, e.to_s)
    raise ActiveRecord::Rollback
  end

  def create_company(company_file)
    Company.create!(
      cnpj: company_file.css('CNPJ').text,
      name: company_file.css('xNome').text,
      trade_name: company_file.css('xFant').text
    )
  rescue => e
    errors.add(:create_company, e.to_s)
    raise ActiveRecord::Rollback
  end

  def create_invoice(invoice_file, company_emit, company_dest)
    Invoice.create!(
      serial_number: invoice_file.css('serie').text,
      invoice_number: invoice_file.css('nNF').text,
      emission_date: invoice_file.css('dhEmi').text,
      issuing_company_id: company_emit.id,
      recipient_company_id: company_dest.id
    )
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:create_invoice, e.to_s)
    raise ActiveRecord::Rollback
  end

  private

  def instance_product(product_file, invoice_id)
    Product.new(
      invoice_id: invoice_id,
      name: product_file.css('xProd').text,
      ncm: product_file.css('NCM').text,
      cfop: product_file.css('CFOP').text,
      unit_c: product_file.css('uCom').text,
      quantity_c: product_file.css('qCom').text,
      unit_price: product_file.css('vUnCom').text,
      icms_price: product_file.at_css('imposto > ICMS > ICMS00 > vICMS')&.text,
      ipi_price: product_file.at_css('imposto > IPI > IPITrib > vIPI')&.text,
      pis_price: product_file.at_css('imposto > PIS > PISNT > vPIS')&.text,
      cofins_price: product_file.at_css('imposto > COFINS > COFINSNT > vCOFINS')&.text
    )
  end

  def update_error_job(error)
    return if @job.blank?

    @job.update_columns(
      job_errors: [error], status: Job::FAILURE, progress: 100
    )
  end

  def error_handling(name, error)
    errors.add(name, error)

    update_error_job(error)
  end
end
