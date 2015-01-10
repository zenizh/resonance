module ActsInRelation
  module Source
    def define
      with.each do |action|
        action.extend ActsInRelation::Supports::Verb

        class_object.class_eval <<-RUBY
          has_many :"#{action.pluralize}",
            foreign_key: :"#{source}_id",
            dependent: :destroy

          has_many :"#{action.progressize}",
            through: :"#{action.pluralize}",
            source: :"target_#{target}"

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
        RUBY
      end
    end
  end
end
