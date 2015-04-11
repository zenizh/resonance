module ActsInRelation
  class Railtie < Rails::Railtie
    initializer 'acts_in_relation' do
      ActiveSupport.on_load :active_record do
        include ActsInRelation::Core
      end
    end
  end
end
