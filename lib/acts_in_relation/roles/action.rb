module ActsInRelation
  module Roles
    class Action < Base
      def define
        @class.class_eval <<-RUBY
          belongs_to :"#{source}"

          belongs_to :"target_#{target}",
            class_name: "#{target.capitalize}",
            foreign_key: :"target_#{target}_id"
        RUBY
      end
    end
  end
end
