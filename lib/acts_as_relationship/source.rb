module ActsAsRelationship
  module Source
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_relation_source(target:, with:)
        with = *with.map(&:to_s)

        with.each do |action|
          action.extend ActsAsRelationship::Verb

          has_many :"#{action.pluralize}",           dependent: :destroy, foreign_key: :"#{target}_id"
          has_many :"#{action.pluralize}_as_target", dependent: :destroy, foreign_key: :"target_#{target}_id", class_name: action.capitalize

          has_many :"#{action.progressize}", through: :"#{action.pluralize}",           source: :"target_#{target}"
          has_many :"#{action.peoplize}",    through: :"#{action.pluralize}_as_target", source: :"#{target}"

          self.class_eval <<-RUBY
            def #{action}(target)
              return if #{action.progressize}?(target) || (self == target)

              #{action.pluralize}.create(target_#{target}_id: target.id)
            end

            def un#{action}(target)
              return unless #{action.progressize}?(target)

              #{action.pluralize}.find_by(target_#{target}_id: target.id).destroy
            end

            def #{action.progressize}?(target)
              #{action.pluralize}.exists?(target_#{target}_id: target.id)
            end

            def #{action.pastize}_by?(target)
              target.#{action.pluralize}.exists?(#{target}_id: target.id)
            end
          RUBY
        end
      end
    end
  end
end
