require 'rails'

module ActsAsRelationship
  class Railtie < Rails::Railtie
    initializer 'acts_as_relationship' do |app|
      ActiveSupport.on_load :active_record do
        include ActsAsRelationship::Source
        include ActsAsRelationship::Target
      end
    end
  end
end
