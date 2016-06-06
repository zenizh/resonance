require 'inflexion'

module Resonance
  class ArgumentError < StandardError; end

  module ClassMethods
    def resonate(source, target: nil, action: nil, foreign_key: {})
      roles = [source, target, action]

      roles.each do |role|
        if role.nil?
          raise Resonance::ArgumentError, 'Passed argument is not a valid'
        end
      end

      foreign_key.tap do |key|
        key[:source] = :"#{source}_id"        if key[:source].nil?
        key[:target] = :"target_#{target}_id" if key[:target].nil?
      end

      Resonance.define(*roles.map(&:to_s), foreign_key)
    end
  end

  class << self
    def included(base)
      base.extend(ClassMethods)
    end

    def define(source, target, action, foreign_key)
      classize(source).class_eval <<-EOS
        has_many :#{action.pluralize},
          foreign_key: :#{source}_id,
          dependent: :destroy

        has_many :#{action.progressize},
          through: :#{action.pluralize},
          source: :target_#{target}

        def #{action}(target)
          if #{action.progressize}?(target) || (self == target)
            return
          end

          #{action.pluralize}.create(#{foreign_key[:target]}: target.id)
        end

        def un#{action}(target)
          unless #{action.progressize}?(target)
            return
          end

          #{action.pluralize}.find_by(#{foreign_key[:target]}: target.id).destroy
        end

        def #{action.progressize}?(target)
          #{action.pluralize}.exists?(#{foreign_key[:target]}: target.id)
        end
      EOS

      classize(target).class_eval <<-EOS
        has_many :#{action.pluralize}_as_target,
          foreign_key: :#{foreign_key[:target]},
          class_name: '#{classize(action)}',
          dependent: :destroy

        has_many :#{action.peopleize},
          through: :#{action.pluralize}_as_target,
          source: :#{source}

        def #{action.pastize}_by?(source)
          source.#{action.pluralize}.exists?(#{foreign_key[:target]}: id)
        end
      EOS

      classize(action).class_eval <<-EOS
        belongs_to :#{source}

        belongs_to :target_#{target},
          class_name: '#{classize(target)}',
          foreign_key: :#{foreign_key[:target]}
      EOS
    end

    private

    def classize(str)
      str.camelize.constantize
    end
  end
end
