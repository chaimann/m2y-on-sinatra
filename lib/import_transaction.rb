class ImportTransaction
  ACCOUNTS_MAP = {
    ENV['M_ACC_ID1'] => ENV['Y_ACC_ID1'],
    ENV['M_ACC_ID2'] => ENV['Y_ACC_ID2'],
    ENV['M_ACC_ID3'] => ENV['Y_ACC_ID3'],
  }

  BUDGET_ID = ENV['BUDGET_ID']

  def initialize(account_id, item)
    @account_id = account_id
    @item = item
  end

  def perform
    ynab_client.transactions.create_transaction(BUDGET_ID, transaction_data)
    true
  rescue YNAB::ApiError => e
    puts "==== ERROR: id=#{e.id}; name=#{e.name}; detail: #{e.detail}"
  end

  def transaction_data
    {
      transaction: {
        import_id: @item[:id],
        account_id: ACCOUNTS_MAP.fetch(@account_id),
        date: Time.at(@item[:time]).to_date,
        payee_name: @item[:description],
        memo: @item[:commission_rate].zero? ? nil : "rate: #{@item[:commission_rate]}",
        amount: @item[:amount] * 10
      }
    }
  end

  private

  def ynab_client
    @ynab_client ||= YNAB::API.new(ENV['YNAB_ACCESS_TOKEN'])
  end
end
