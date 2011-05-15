module DK
  module ActWithBag #:nodoc:

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def add_to_bag(*baglets)
#p "baglets #{baglets.inspect}"
	serialize :bag, Hash

	self.class_eval %{
	  def bag=(x)
	    #bag changes disabled as it must be handled by Bag himself
	  end
	}
	model = model_sym
	@baggies ||= {}
	@baggies[model] ||= {}
	baglets.each {|b|
	  if b.is_a?(Hash)
	    b.each {|baggie, type|
	      @baggies[model].merge!(baggie => type)
	      add_accessor(baggie)
	    }
	  else
	    @baggies[model].merge!(b => :string)
	    add_accessor(b)
	  end
	}
      end

      def baggies
	@baggies ||= {}
	@baggies[model_sym] || {}
      end

      def merge(bag, params)
	model = model_sym
	return params unless params[model]

	baggies.each {|baggie, type|
	  if type == :date
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
	  end
	}
	params
      end

     private
      def model_sym
	self.to_s.underscore.to_sym
      end

      def free_accessor(str)
	accessor = str.to_sym
	return accessor unless self.method_defined?(accessor)
	logger.info "** Already defined #{self.to_s}.#{accessor}"
#p "** Bag: untouched accessor '#{self.to_s}.#{accessor}'"
	nil
      end

      def add_accessor(baggie)
#p "add_accessor #{self.to_s} #{baggie.inspect}"
	accessor = free_accessor("#{baggie.to_s}")
	if accessor
	  self.class_eval %{
	    def #{accessor}
	      res = bag && bag[:#{baggie}]
	      if #{self.to_s}.baggies[:#{baggie}] == :boolean
		return res if res.class == FalseClass
		return res if res.class == TrueClass
		return res.to_i != 0
	      end
	      res
	    end
	  }
	end

	accessor = free_accessor("#{baggie.to_s}=")
	if accessor
	  self.class_eval %{
	    def #{accessor}(value)
	      @attributes['bag'] = {}  unless bag.is_a?(Hash)
	      self.bag.merge!(:#{baggie} => value)
	    end
	  }
	end

	return  unless baggies["#{baggie}".to_sym] == :boolean
	accessor = free_accessor("#{baggie.to_s}?")
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
  end
end
