require 'ynab'

class ImportTransaction
  ACCOUNTS_MAP = {
    ENV['MONO_WHITE_ACC_ID'] => ENV['YNAB_WHITE_ACC_ID'],
    ENV['MONO_BLACK_ACC_ID'] => ENV['YNAB_BLACK_ACC_ID'],
    ENV['MONO_USD_ACC_ID']   => ENV['YNAB_USD_ACC_ID'],
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
