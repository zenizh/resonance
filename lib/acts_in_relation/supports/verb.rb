require 'verbs'

module ActsInRelation
  module Supports
    module Verb
      PATCHES = {
        'follow' => 'following'
      }

      def pastize(object)
        object.verb.conjugate(tense: :past).split(' ').last
      end

      def progressize(object)
        return PATCHES[object] if PATCHES.has_key?(object)

        object.verb.conjugate(aspect: :progressive).split(' ').last
      end

      # @todo Implement more logically
      def peoplize(object)
        (object.last == 'e' ? object.chop : object) + 'ers'
      end
    end
  end
end
