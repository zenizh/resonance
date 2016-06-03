require 'resonance/errors/argument_error'
require 'resonance/supports/converter'

module Resonance
  class << self
    def included(base)
      base.extend(ClassMethods)
    end
  end

  module ClassMethods
    include Resonance::Supports::Converter

    def resonate(source, target: nil, action: nil, foreign_key: {})
      [source, target, action].each do |role|
        if role.nil?
          raise Resonance::Errors::ArgumentError, 'Passed argument is not a valid'
        end
      end

      source = source.to_s
      target = target.to_s
      action = action.to_s

      foreign_key.tap do |key|
        key[:source] = :"#{source}_id"        if key[:source].nil?
        key[:target] = :"target_#{target}_id" if key[:target].nil?
      end

      classify(source).class_eval <<-EOS
        has_many :#{pluralize(action)},
          foreign_key: :#{source}_id,
          dependent: :destroy

        has_many :#{progressize(action)},
          through: :#{pluralize(action)},
          source: :target_#{target}

        def #{action}(target)
          if #{progressize(action)}?(target) || (self == target)
            return
          end

          #{pluralize(action)}.create(#{foreign_key[:target]}: target.id)
        end

        def un#{action}(target)
          unless #{progressize(action)}?(target)
            return
          end

          #{pluralize(action)}.find_by(#{foreign_key[:target]}: target.id).destroy
        end

        def #{progressize(action)}?(target)
          #{pluralize(action)}.exists?(#{foreign_key[:target]}: target.id)
        end
      EOS

      classify(target).class_eval <<-EOS
        has_many :#{pluralize(action)}_as_target,
          foreign_key: :#{foreign_key[:target]},
          class_name: '#{classify(action)}',
          dependent: :destroy

        has_many :#{peoplize(action)},
          through: :#{pluralize(action)}_as_target,
          source: :#{source}

        def #{pastize(action)}_by?(source)
          source.#{pluralize(action)}.exists?(#{foreign_key[:target]}: id)
        end
      EOS

      classify(action).class_eval <<-EOS
        belongs_to :#{source}

        belongs_to :target_#{target},
          class_name: '#{classify(target)}',
          foreign_key: :#{foreign_key[:target]}
      EOS
    end
  end
end
