class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
    @subscriptions = current_user.subscriptions
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    # @amount = 500
    #
    # customer = Stripe::Customer.create({
    #                                        email: current_user.email,
    #                                        source: params[:stripeToken],
    #                                    })
    #
    # charge = Stripe::Charge.create({
    #                                    customer: customer.id,
    #                                    amount: @amount,
    #                                    description: 'Rails Stripe customer',
    #                                    currency: 'usd',
    #                                })
    # @payment = Payment.new(amount: @amount, subscription_id: params[:subscription_id], token: params[:stripeToken])
    # rescue Stripe::CardError => e
    #   flash[:error] = e.message
    #   redirect_to new_payment_path

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      # params.fetch(:payment, {})
      params.require(:payment).permit(:subscription_id)
    end
end
