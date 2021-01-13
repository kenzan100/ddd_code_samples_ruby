require "test/unit"
require "date"
require_relative './contract'
require_relative './claim'

class ContractTest < Test::Unit::TestCase
  def test_contract_is_setup_correctly
    product = make_product
    contract = Contract.new(100.0, product)

    assert_equal 100, contract.purchase_price
    assert_equal "PENDING", contract.status
    assert_equal "Whirlpool", contract.covered_product.make
  end

  def test_limit_of_liability_reached_returns_true
    contract = make_contract
    new_claim = Claim.new(10.0, Date.new(2010, 5, 8))

    assert contract.limit_of_liability_reached?(new_claim)
  end

  def test_limit_of_liability_reached_returns_false_nonactive_status
    contract = make_contract(status: "PENDING")
    new_claim = Claim.new(10.0, Date.new(2010, 5, 8))

    assert_equal false, contract.limit_of_liability_reached?(new_claim)
  end

  def test_limit_of_liability_reached_returns_false_expired_contract
    contract = make_contract(expiration_date: Date.new(2011, 5, 8))
    new_claim = Claim.new(10.0, Date.new(2011, 5, 9))

    assert_equal false, contract.limit_of_liability_reached?(new_claim)
  end

  def test_limit_of_liability_reached_returns_false_amount_not_enough
    contract = make_contract
    contract.claims << Claim.new(100.0, Date.new(2010, 5, 8))
    new_claim = Claim.new(10.0, Date.new(2010, 5, 8))

    assert_equal false, contract.limit_of_liability_reached?(new_claim)
  end


  ## Test Helper
  def make_product
    Product.new("dishwasher", "OEUOEU23", "Whirlpool", "7DP840CWDB0")
  end

  def make_contract(**override)
    product = make_product

    contract = Contract.new(100.0, product)
    contract.effective_date  = override[:effective_date] || Date.new(2010, 5, 8)
    contract.expiration_date = override[:expiration_date] || Date.new(2012, 5, 8)
    contract.status          = override[:status] || "ACTIVE"
    contract
  end
end
