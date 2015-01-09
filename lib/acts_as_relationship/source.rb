module ActsAsRelationship
  module Source
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_relation_source(target:, with:)
        with = *with.map(&:to_s)

        with.each do |action|
          has_many :"#{action.pluralize}",           dependent: :destroy
          has_many :"#{action.pluralize}_as_target", dependent: :destroy, class_name: action.capitalize, foreign_key: :"target_#{target}_id"

          self.class_eval <<-RUBY
            def #{action}(target)
              #{action.pluralize}.create(target_#{target}_id: target.id)
            end

            def un#{action}(target)
              return unless #{action}ing?(target)

              #{action.pluralize}.find_by(target_#{target}_id: target.id).destroy
            end

            def #{action}ing?(target)
              #{action.pluralize}.exists?(target_#{target}_id: target.id)
            end

            def #{action}ed_by?(target)
              target.#{action.pluralize}.exists?(#{target}_id: target.id)
            end

            def #{action}ing
              #{action.pluralize}
            end

            def #{action}ers
              #{action.pluralize}_as_target
            end
          RUBY
        end
      end
    end
  end
end
