ActWithBag
==========
[![Gem Version](https://badge.fury.io/rb/act_with_bag.png)](http://badge.fury.io/rb/act_with_bag)
[![Build Status](https://travis-ci.org/matique/act_with_bag.png?branch=master)](https://travis-ci.org/matique/act_with_bag)
[![Coverage Status](https://coveralls.io/repos/matique/act_with_bag/badge.png)](https://coveralls.io/r/matique/act_with_bag)

In Gemfile:
  gem 'act_with_bag'

Bag helps when fields in a table are not yet settled down
or when many fields without business logic are required.

Install one bag in a table to collect many fields.
Additional fields or removal of them are easy.
No migration is required for new fields.

Keep in mind that the collection is kept in a YAML bag, i.e.
SQL commands can't access the fields.

Boolean and Date fields require explicit typing, others are
treated as string.

Technical background: getters and putters are injected into models.
If baggies of type :date are being used then
params must be corrected before an update_attributes.
Warning: :date fields are not well integrated; avoid them.

Obsolete fields are deleted before_save by:
  delete_from_bag :field


Example
=======

In model:
  class Order < ActiveRecord::Base
    add_to_bag :name, :color, :description,
	{:active => :boolean},
	{:paused_at => :date}

In controller:
  class OrdersController < ApplicationController
    def create
      params = Order.merge({}, self.params)   # only if type :date is being used
      @order = Order.new(params[:order])

    def update
      @order = Order.find(params[:id])
      params = Order.merge(@order.bag, self.params) # only if type :date is being used

Test
====

rake


Copyright (c) 2009-2011 [Dittmar Krall], released under the MIT license
