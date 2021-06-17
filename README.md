ActWithBag
==========
[![Gem Version](https://badge.fury.io/rb/act_with_bag.png)](http://badge.fury.io/rb/act_with_bag)

In Gemfile:

    gem 'act_with_bag'

Bag helps when fields in a Rails database table are not yet settled down
or when many fields without business logic are required.

Install (migrate) one bag as a text field in a table to collect many fields.
Additional fields or removal of them are easy;
no migrations are required for them.

Keep in mind that the collection is kept in a YAML bag,
i.e. SQL commands can't access the bag fields.

Boolean and Date fields require explicit typing.

Fields without typing accept any values which YAML can handle
(e.g. @order.colors = ['red', 'yellow']).

Types :integer, :float and :string
forces a conversion (.to_i, .to_f, .to_s) before storing the value,
a convenience similar to ActiveRecord handling due to migration definitions.

Technical background: getters and putters are injected into models.

If baggies of type :date are being used then
params must be corrected before an update_attributes.
Warning: :date fields are not well integrated; avoid them.

Obsolete fields are deleted before_save by:

    delete_from_bag :field


Warning
=======

1. Please add a:

    serialize :bag, Hash

to each subclass accessing a bag field from a superclass.
Using an "add_to_bag" in the subclass obsoletes the "serialize".

2. delete_from_bag just delete the field from the record being saved.
Other records are untouched,
i.e. the value of the field will be kept in the database.


Example
=======

In model:

    class Order < ActiveRecord::Base
     add_to_bag :name,
      :color,
      :description,
      {idx: :integer},
      {price: :float},
      {active: :boolean},
      {paused_at: :date},
      {msg: :string}

     def to_s
      "Order #{name} #{color} #{price}"
     end
     ...

In controller:

    class OrdersController < ApplicationController

     def create
      params = Order.merge({}, self.params)   # only if type :date is being used
      @order = Order.new(params[:order])
      @order.price = 1.23
      logger.info "Order #{@order.to_s} repriced to #{@order.price}"
      ...
     def update
      @order = Order.find(params[:id])
      params = Order.merge(@order.bag, self.params) # only if type :date is being used
      @order.update_attributes(params[:order])

Test
====

    rake

Copyright (c) 2009-2020 [Dittmar Krall], released under the MIT license
