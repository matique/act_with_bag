# frozen_string_literal: true

class << ActiveRecord::Base
  def add_to_bag(*baglets)
    # p "baglets #{baglets.inspect}"
    # if Rails.version < "7.1.0"
    #   serialize :bag, Hash
    # else
    #   serialize :bag, type: Hash, coder: YAML
    # end
    serialize :bag, Hash

    class_eval %{
      unless method_defined?(:bag=)
        def bag=(x)
          #bag changes disabled as it must be handled by Bag himself
        end
      end
    }, __FILE__, __LINE__ - 6

    @baggies_date ||= {}
    baglets.each { |b|
      if b.is_a?(Hash)
        b.each { |baggie, type|
          add_accessor(baggie, type)
        }
      else
        add_accessor(b, :field)
      end
    }
  end

  def delete_from_bag(*baglets)
    # p "delete_from_bag baglets #{baglets.inspect}"

    class_eval %{
      before_save do
        #{baglets}.each { |b|
          if b.is_a?(Hash)
            b.each { |baggie, type|
              self.bag.delete(baggie.to_sym)
            }
          else
            self.bag.delete(b.to_sym)
          end
        }
      end
    }, __FILE__, __LINE__ - 12
  end

  def merge(_bag, params)
    model = to_s.underscore.to_sym
    return params unless params[model]

    (@baggies_date || {}).each { |baggie, _type|
      res = []
      found = false
      stopped = false
      (1..3).each { |i|
        p = params[model].delete("#{baggie}(#{i}i)")
        break if p.nil?

        found = true
        stopped = true if p.empty?
        res << p.to_i unless stopped
      }
      next unless found

      ## weird Timestamp, Hash and YAML problem
      res = [0] if res == []
      res[0] = 0 unless res[0] >= 0

      value = begin
        Date.new(*res)
      rescue
        nil
      end
      params[model][baggie] = value
    }
    params
  end

  protected

  def accessor_present?(accessor)
    accessor_sym = accessor.to_sym
    res = false

    res = true if method_defined?(accessor_sym)
    res = true if respond_to?(:attribute_names) &&
      attribute_names.include?(accessor)
    if res
      #      logger.info "** Already defined #{self.to_s}.#{accessor}"
      # p "** act_to_bag: untouched accessor '#{self.to_s}.#{accessor}'"
    end
    res
  end

  def add_accessor(baggie, type)
    accessor = baggie.to_s
    return if accessor_present?(accessor)

    # MARS patch, new:
    #
    # The @baggies field is indispensable. Otherwise mistakes in renaming
    # or deleting baggies (without renaming/deleting) the value entry from the
    # bag, e. g. via delete_from_bag) cannot be detected in a clean way.
    # Detecting the accessor would be not sufficient, as the accessor may be
    # created by ActiveRecord::Base or the derived model and it may be
    # doing completely other things (e. g. accessing a database column).
    #
    @baggies ||= {}
    baggies = (@baggies[to_s.underscore.to_sym] ||= {})
    baggies[baggie] = type
    # END

    type_sym = type.to_sym
    typing = {integer: ".to_i", float: ".to_f",
              string: ".to_s"}[type_sym] || ""
    # p "add_accessor #{self.to_s} #{baggie.inspect} #{type_sym.inspect}"

    @baggies_date[baggie] = type if type_sym == :date

    if type_sym == :boolean
      class_eval %(
        def #{accessor}
          res = bag && bag[:#{baggie}]
          return res if res.class == FalseClass
          return res if res.class == TrueClass
          return res.to_i != 0
        end
      ), __FILE__, __LINE__ - 7

      class_eval %(
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
      ), __FILE__, __LINE__ - 11

      class_eval %(
        def #{accessor}?
          #{accessor}
        end
      ), __FILE__, __LINE__ - 4

    else

      class_eval %(
        def #{accessor}
          self.bag && self.bag[:#{baggie}]
        end
      ), __FILE__, __LINE__ - 4

      class_eval %(
        def #{accessor}=(value)
          @attributes['bag'] = {}  unless bag.is_a?(Hash)
          unless value.nil?
            self.bag[:#{baggie}] = value#{typing}
          else
            self.bag.delete(:#{baggie})
            nil
          end
        end
      ), __FILE__, __LINE__ - 10
    end
  end
end
