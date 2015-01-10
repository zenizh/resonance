module ActsInRelation
  module Action
    def define
      class_object.class_eval <<-RUBY
        belongs_to :"#{source}"
        belongs_to :"target_#{target}", class_name: "#{target.capitalize}", foreign_key: :"target_#{target}_id"
      RUBY
    end
  end
end
