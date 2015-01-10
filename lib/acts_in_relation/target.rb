module ActsInRelation
  module Target
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def define
        with.each do |action|
          action.extend ActsInRelation::Supports::Verb

          has_many :"#{action.pluralize}_as_target",
            foreign_key: :"target_#{target}_id",
            class_name: action.capitalize,
            dependent: :destroy

          has_many :"#{action.peoplize}",
            through: :"#{action.pluralize}_as_target",
            source: :"#{source}"

          self.class_eval <<-RUBY
            def #{action.pastize}_by?(source)
              source.#{action.pluralize}.exists?(#{source}_id: source.id)
            end
          RUBY
        end
      end
    end
  end
end
