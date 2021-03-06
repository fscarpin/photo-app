class ChargesController < ApplicationController

  def new
  end

  def create
    # Amount in cents
    @amount = 15000

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Amazing Photo App lifetime subscription',
      :currency    => 'usd'
    )

    current_user.payment = true
    current_user.save

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
