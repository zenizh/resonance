module ActsInRelation
  module Roles
    class Source < Base
      def define
        actions.each do |action|
          @class.class_eval <<-RUBY
            has_many :"#{action.pluralize}",
              foreign_key: :"#{source}_id",
              dependent: :destroy

            has_many :"#{progressize(action)}",
              through: :"#{action.pluralize}",
              source: :"target_#{target}"

            def #{action}(target)
              return if #{progressize(action)}?(target) || (self == target)

              #{action.pluralize}.create(target_#{target}_id: target.id)
            end

            def un#{action}(target)
              return unless #{progressize(action)}?(target)

              #{action.pluralize}.find_by(target_#{target}_id: target.id).destroy
            end

            def #{progressize(action)}?(target)
              #{action.pluralize}.exists?(target_#{target}_id: target.id)
            end
          RUBY
        end
      end
    end
  end
end
