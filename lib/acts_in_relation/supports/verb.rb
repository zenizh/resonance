require 'verbs'

module ActsInRelation
  module Supports
    module Verb
      PATCHES = {
        'follow' => 'following'
      }

      def pastize
        verb.conjugate(tense: :past).split(' ').last
      end

      def progressize
        return PATCHES[self] if PATCHES.has_key?(self)

        verb.conjugate(aspect: :progressive).split(' ').last
      end

      # TODO: Implement this method more logically
      def peoplize
        action = (last == 'e') ? chop : self
        action + 'ers'
      end
    end
  end
end
