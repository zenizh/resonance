module ActsInRelation
  module Action
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def define
        belongs_to :"#{source}"
        belongs_to :"target_#{target}", class_name: "#{target.capitalize}", foreign_key: :"target_#{target}_id"
      end
    end
  end
end
