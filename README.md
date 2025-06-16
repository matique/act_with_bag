# ActWithBag

[![Gem Version](https://img.shields.io/gem/v/act_with_bag?color=168AFE&logo=rubygems&logoColor=FE1616)](https://rubygems.org/gems/act_with_bag)
[![Downloads](https://img.shields.io/gem/dt/act_with_bag?color=168AFE&logo=rubygems&logoColor=FE1616)](https://rubygems.org/gems/act_with_bag)
[![GitHub Build](https://img.shields.io/github/actions/workflow/status/matique/act_with_bag/rake.yml?logo=github)](https://github.com/matique/act_with_bag/actions/workflows/rake.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/standardrb/standard)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit/)

## 22
[![Gem Version](https://badge.fury.io/rb/act_with_bag.svg)](http://badge.fury.io/rb/act_with_bag)
[![GEM Downloads](https://img.shields.io/gem/dt/act_with_bag?color=168AFE&logo=ruby&logoColor=FE1616)](https://rubygems.org/gems/act_with_bag)
[![rake](https://github.com/matique/act_with_bag/actions/workflows/rake.yml/badge.svg)](https://github.com/matique/act_with_bag/actions/workflows/rake.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/standardrb/standard)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit/)

## 33
[![Gem Version](https://img.shields.io/gem/v/act_with_bag?color=168AFE&logo=rubygems&logoColor=FE1616)](https://rubygems.org/gems/act_with_bag)
[![Downloads](https://img.shields.io/gem/dt/act_with_bag?color=168AFE&logo=rubygems&logoColor=FE1616)](https://rubygems.org/gems/act_with_bag)
[![GitHub Build](https://img.shields.io/github/actions/workflow/status/matique/act_with_bag/rake.yml?logo=github)](https://github.com/matique/act_with_bag/actions/workflows/rake.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard.svg)](https://github.com/standardrb/standard)
[![MIT License](https://img.shields.io/badge/license-MIT.svg)](http://choosealicense.com/licenses/mit/)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit/)

Bag helps when fields in a Rails database table are not yet settled down
or when many fields without business logic are required.

## Installation

As usual:
```ruby
# Gemfile
gem "act_with_bag"
```
and run "bundle install".

## Usage

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


## Warning

1. Please add a:

    serialize :bag, Hash

to each subclass accessing a bag field from a superclass.
Using an "add_to_bag" in the subclass obsoletes the "serialize".

2. delete_from_bag just delete the field from the record being saved.
Other records are untouched,
i.e. the value of the field will be kept in the database.

3. Keep an eye on YAML, the library to serialize the "bag",
which for some versions is not tamper-proof
and may required additional configuration in Rails.

See also:
~~~
https://stackoverflow.com/questions/72970170/upgrading-to-rails-6-1-6-1-causes-psychdisallowedclass-tried-to-load-unspecif
~~~

The configuration
"Rails.application.config.active_record.use_yaml_unsafe_load = true"
is not recommended as it is a patch prone to attacks.

The configuration
"Rails.application.config.active_record.yaml_column_permitted_classes = [Symbol]"
may be incomplete requiring additional classes like "Time" and "Date".
(credits to Martin Schöttler).

## Example

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

## Test

    bundle exec rake

## Miscellaneous

Copyright (c) 2009-2024 Dittmar Krall (www.matiq.com),
released under the [MIT license](https://opensource.org/licenses/MIT).
