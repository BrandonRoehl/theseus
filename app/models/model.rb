class Model < ActiveRecord::Base
    has_many :instances, dependent: :delete_all

    before_save do
        self.name = self.name.camelize
    end

    def self.add(class_name)
        class_name = class_name.to_s.camelize
        model = self.find_or_create_by(name: class_name)

        klass = Kernel.const_set(
            model.name,
            Class.new(Instance) do
                # Default to blank
                @cache = {}
                @keys = nil

                # every models scope
                default_scope {where(model_id: model.id)}

                # every model has a custom delete method
                @model = model
                def self.destroy
                    Kernel.send(:remove_const, @model.name)
                    Model.destroy(@model.id)
                end
            end
        )
        return klass
    end

    class Instance < ActiveRecord::Base
        self.abstract_class = true
        # Set the primary key
        self.primary_key = :key
        self.table_name = :instances
        serialize :value
        # Cache to avoid extra queries and dramatically increase speed

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
                if @cache[key] ||= self.find_by(key: key)
                    @cache[key].value
                else
                    nil
                end
            end

            def []=(key, value)
                # key to_sym so we can have a consistent value
                key = key.to_sym
                # Find a setting if we haven't looked it up and define
                # it if it is not initialized
                @cache[key] ||= self.find_or_initialize_by(key: key)
                @cache[key].value = value
                @cache[key].save
                # Bake keys together if they have been retrieved
                # this is a union assignment operator
                @keys |= [key] if @keys
            end

            def keys
                @keys ||= self.all.pluck(:key).map(&:to_sym)
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
    private_constant :Instance
end

