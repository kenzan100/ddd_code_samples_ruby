require_relative './product'
class Contract
  attr_reader   :id # unique id (assigned automatically)
  attr_reader   :purchase_price
  attr_reader   :covered_product

  attr_accessor :status
  attr_accessor :effective_date
  attr_accessor :expiration_date
  attr_accessor :purchase_date
  attr_accessor :in_store_guarantee_days
  attr_accessor :claims

  def initialize(purchase_price, covered_product)
    @purchase_price     = purchase_price
    @status             = "PENDING"
    @claims             = Array.new
    @covered_product    = covered_product
  end

  def limit_of_liability_reached?(new_claim)
    # if amount left * 0.8 is enough to cover the new claim amount, we'll proceed
    amount_left = purchase_price - claim_total
    enough_amount_left = amount_left * 0.8 > new_claim.amount
    within_range = new_claim.date >= effective_date && new_claim.date <= expiration_date

    enough_amount_left && within_range && status == "ACTIVE"
  end

  private

  def claim_total
    claims.reduce(0) do |sum, claim|
      sum += claim.amount
    end
  end
end
