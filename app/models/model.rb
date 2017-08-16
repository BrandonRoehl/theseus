class Model < ApplicationRecord
    before_save do
        self.name = self.name.camelize
    end
end
