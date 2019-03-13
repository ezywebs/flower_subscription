class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.all
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
    @addresses = current_user.addresses
    @products = Product.all
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    p "in subs controller create"
    @subscription = Subscription.new(subscription_params)


    @amount = 500
    @payment = Payment.new(amount: @amount, token: params[:payment][:token])
    customer = find_customer
    begin
      charge = Stripe::Charge.create({
                                         customer: customer.id,
                                         amount: @amount,
                                         description: 'Rails Stripe customer',
                                         currency: 'usd',
                                     })
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_subscription_path
    end


    @subscription.next_delivery = DateTime.now.to_date
    @subscription.prev_delivery = DateTime.now.to_date
    @subscription.user = current_user


    respond_to do |format|
      if @subscription.save
        @payment.subscription = @subscription
        @payment.save
        p "after save #{@payment}"
        format.html { redirect_to @subscription, notice: 'Subscription was successfully created.' }
        format.json { render :show, status: :created, location: @subscription }
      else
        format.html { render :new }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { render :show, status: :ok, location: @subscription }
      else
        format.html { render :edit }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to subscriptions_url, notice: 'Subscription was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      # params.fetch(:subscription, {})
      params.require(:subscription).permit(:frequency, :product_id, :address_id, :token)
    end

    def find_customer
      if current_user.stripe_token
        retrieve_customer(current_user.stripe_token)
      else
        create_customer
      end
    end

    def retrieve_customer(stripe_token)
      Stripe::Customer.retrieve(stripe_token)
    end

    def create_customer
      customer = Stripe::Customer.create(
          email: current_user.email,
          source: params[:payment][:token]
      )
      # customer.sources.create({source: params[:token]})
      current_user.update(stripe_token: customer.id)
      customer
    end
end