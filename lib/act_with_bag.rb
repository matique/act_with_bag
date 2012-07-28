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
	add_accessor(b, :string)
      end
    }
  end

  def delete_from_bag(*baglets)
#p "delete_from_bag baglets #{baglets.inspect}"

    self.class_eval %{
      before_save :baggies_delete
      def baggies_delete
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
  def free_accessor(str)
    accessor = str.to_sym
    return accessor unless self.method_defined?(accessor)
    logger.info "** Already defined #{self.to_s}.#{accessor}"
#p "** Bag: untouched accessor '#{self.to_s}.#{accessor}'"
    nil
  end

  def add_accessor(baggie, type)
    baggie_s = baggie.to_s
    type_sym = type.to_sym
#p "add_accessor #{self.to_s} #{baggie.inspect} #{type_sym.inspect}"

    accessor = free_accessor("#{baggie_s}")
    if accessor
      self.class_eval %{
	def #{accessor}
	  res = bag && bag[:#{baggie}]
	end
      }
    end

    accessor = free_accessor("#{baggie_s}=")
    if accessor
      @baggies_date[baggie] = type  if type == :date
      self.class_eval %{
	def #{accessor}(value)
	  @attributes['bag'] = {}  unless bag.is_a?(Hash)
	  unless value.nil?
	    self.bag[:#{baggie}] = value
	  else
	    self.bag.delete(:#{baggie})
	    nil
	  end
	end
      }
    end

    return  unless type_sym == :boolean
    accessor = free_accessor("#{baggie_s}?")
    if accessor
      self.class_eval %{
	def #{accessor}
	  res = bag && bag[:#{baggie}]
	  return res if res.class == FalseClass
	  return res if res.class == TrueClass
	  res.to_i != 0
	end
      }
    end
  end

end
