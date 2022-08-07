class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def show
    Order.create name: "hugo"
    @order = Order.find(params[:id])
  end
end
