class << ActiveRecord::Base

  def add_to_bag(*baglets)
#p "baglets #{baglets.inspect}"
    serialize :bag, Hash

    self.class_eval %{
      def bag=(x)
	#bag changes disabled as it must be handled by Bag himself
      end
    }

    @baggies_date ||= {}
    baglets.each {|b|
      if b.is_a?(Hash)
	b.each {|baggie, type|
	  add_accessor(baggie, type)
	}
      else
	add_accessor(b, :field)
      end
    }
  end

  def delete_from_bag(*baglets)
#p "delete_from_bag baglets #{baglets.inspect}"

    self.class_eval %{
      before_save do
	#{baglets}.each {|b|
	  if b.is_a?(Hash)
	    b.each {|baggie, type|
	      self.bag.delete(baggie.to_sym)
	    }
	  else
	    self.bag.delete(b.to_sym)
	  end
	}
      end
    }

  end

  def merge(bag, params)
    model = self.to_s.underscore.to_sym
    return params unless params[model]

    (@baggies_date || {}).each {|baggie, type|
      res, found, stopped = [], false, false
      (1..3).each {|i|
	p = params[model].delete("#{baggie}(#{i}i)")
	break if p.nil?
	found = true
	stopped = true if p.empty?
	res << p.to_i unless stopped
      }
      next unless found
  ## weird Timestamp, Hash and YAML problem
      res = [0]  if res == []
      res[0] = 0  unless res[0] >= 0

      value = Date.new(*res) rescue value = nil
      params[model][baggie] = value
    }
    params
  end


 protected
  def accessor_present?(accessor)
    accessor_sym = accessor.to_sym
    res = false

    res = true  if self.method_defined?(accessor_sym)
    res = true  if self.respond_to?(:attribute_names) &&
		   self.attribute_names.include?(accessor)
    if res
#      logger.info "** Already defined #{self.to_s}.#{accessor}"
#p "** act_to_bag: untouched accessor '#{self.to_s}.#{accessor}'"
    end
    return res
  end

  def add_accessor(baggie, type)
    accessor = baggie.to_s
    return  if accessor_present?(accessor)

    type_sym = type.to_sym
    typing = {integer: '.to_i', float: '.to_f',
	      string: '.to_s'}[type_sym] || ''
#p "add_accessor #{self.to_s} #{baggie.inspect} #{type_sym.inspect}"

    @baggies_date[baggie] = type  if type_sym == :date

    unless type_sym == :boolean
      self.class_eval %{
	def #{accessor}
	  self.bag && self.bag[:#{baggie}]
	end
      }

      self.class_eval %{
	def #{accessor}=(value)
	  @attributes['bag'] = {}  unless bag.is_a?(Hash)
	  unless value.nil?
	    self.bag[:#{baggie}] = value#{typing}
	  else
	    self.bag.delete(:#{baggie})
	    nil
	  end
	end
      }

    else   ################ now boolean handling ###################

      self.class_eval %{
	def #{accessor}
	  res = bag && bag[:#{baggie}]
	  return res if res.class == FalseClass
	  return res if res.class == TrueClass
	  return res.to_i != 0
	  res
	end
      }

      self.class_eval %{
	def #{accessor}=(value)
	  @attributes['bag'] = {}  unless bag.is_a?(Hash)
	  falsys = [false, "false", 0, "0", nil]
	  unless falsys.include?(value)
	    self.bag[:#{baggie}] = (value == 'true') || value
	  else
	    self.bag.delete(:#{baggie})
	    nil
	  end
	end
      }

      self.class_eval %{
	def #{accessor}?
	  #{accessor}
	end
      }

    end

  end

end
