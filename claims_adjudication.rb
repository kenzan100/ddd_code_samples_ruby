require_relative './contract'
require_relative './claim'
require 'date'

class ClaimAdjudication
  def adjudicate(contract, new_claim)
    if contract.limit_of_liability_reached?(new_claim)
      contract.claims << new_claim
    end
  end
end
