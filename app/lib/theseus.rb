def _set_class(model)
    model_id = Model.find_by(name: model)

    return Class.new(ActiveRecord::Base) do
        # Set the primary key
        self.primary_key = :key
        self.table_name = :instances
        serialize :value
        default_scope {where(model_id: model_id)}
        # Cache to avoid extra queries and dramatically increase speed
        class_variable_set(:@@cache, {})
        class_variable_set(:@@keys, nil)

        class << self
            include Enumerable

            def method_missing(name, *args)
                if name =~ /^(.*)=$/
                    self[$1] = args[0]
                else
                    self[name]
                end
            end

            def [](key)
                # key to_sym so we can have a consistent value
                key = key.to_sym
                # Only look it up if we haven't before
                if @@cache[key] ||= self.find_by(key: key)
                    @@cache[key].value
                else
                    nil
                end
            end

            def []=(key, value)
                # key to_sym so we can have a consistent value
                key = key.to_sym
                # Find a setting if we haven't looked it up and define
                # it if it is not initialized
                @@cache[key] ||= self.find_or_initialize_by(key: key)
                @@cache[key].value = value
                @@cache[key].save
                # Bake keys together if they have been retrieved
                # this is a union assignment operator
                @@keys |= [key] if @@keys
            end

            def keys
                @@keys ||= self.all.pluck(:key).map(&:to_sym)
            end

            def each
                return enum_for(:each) unless block_given? # Sparkling magic!
                self.keys.each do |key|
                    yield key.to_sym, self[key]
                end
            end

            def to_h
                (self.keys.map { |key|
                    {key => self[key]}
                }).reduce({}, :merge)
            end
            alias_method :as_json, :to_h

            def to_json
                self.to_h.to_json
            end
        end
    end
end

