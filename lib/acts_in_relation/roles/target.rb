module ActsInRelation
  module Roles
    class Target < Base
      def define
        actions.each do |action|
          @class.class_eval <<-RUBY
            has_many :"#{action.pluralize}_as_target",
              foreign_key: :"target_#{target}_id",
              class_name: action.capitalize,
              dependent: :destroy

            has_many :"#{peoplize(action)}",
              through: :"#{action.pluralize}_as_target",
              source: :"#{source}"

            def #{pastize(action)}_by?(source)
              source.#{action.pluralize}.exists?(#{source}_id: source.id)
            end
          RUBY
        end
      end
    end
  end
end
