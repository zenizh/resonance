module ActsAsRelationship
  module Target
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_relation_target(source:)
        belongs_to :"#{source}"
        belongs_to :"target_#{source}", class_name: source.to_s.capitalize, foreign_key: :"target_#{source}_id"
      end
    end
  end
end
