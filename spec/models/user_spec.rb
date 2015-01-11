require 'rails_helper'

describe User, type: :model do
  let(:user)       { User.create(name: 'hoge') }
  let(:other_user) { User.create(name: 'fuga') }

  describe 'instance methods' do
    it 'should be defined' do
      # with: :follow
      expect(user).to respond_to(:follow)
      expect(user).to respond_to(:unfollow)
      expect(user).to respond_to(:following?)
      expect(user).to respond_to(:following)
      expect(user).to respond_to(:followed_by?)
      expect(user).to respond_to(:followers)

      # with: :block
      expect(user).to respond_to(:block)
      expect(user).to respond_to(:unblock)
      expect(user).to respond_to(:blocking?)
      expect(user).to respond_to(:blocking)
      expect(user).to respond_to(:blocked_by?)
      expect(user).to respond_to(:blockers)

      # with: :mute
      expect(user).to respond_to(:mute)
      expect(user).to respond_to(:unmute)
      expect(user).to respond_to(:muting?)
      expect(user).to respond_to(:muting)
      expect(user).to respond_to(:muted_by?)
      expect(user).to respond_to(:muters)

      # target: :post, with: :like
      expect(user).to respond_to(:like)
      expect(user).to respond_to(:unlike)
      expect(user).to respond_to(:liking?)
      expect(user).to respond_to(:liking)
      expect(user).not_to respond_to(:liked_by?)
      expect(user).not_to respond_to(:likers)
    end
  end

  describe '#follow' do
    context 'unfollow user' do
      before { user.follow other_user }

      it 'should be followed' do
        expect(user.follows).to be_exists(target_user_id: other_user.id)
      end
    end

    context 'following user' do
      before do
        user.follow other_user
        user.follow other_user
      end

      it 'should follow only once' do
        expect(user.follows.count).to eq(1)
      end
    end

    context 'user-self' do
      before { user.follow user }

      it 'should not be followed' do
        expect(user.follows).not_to be_exists(target_user_id: user.id)
      end
    end
  end

  describe '#unfollow' do
    context 'following user' do
      before do
        user.follow   other_user
        user.unfollow other_user
      end

      it 'should be unfollowed' do
        expect(user.follows).not_to be_exists(target_user_id: other_user.id)
      end
    end

    context 'unfollow user' do
      it 'should not raise error' do
        expect { user.unfollow other_user } .not_to raise_error
      end
    end
  end

  describe '#following?' do
    before { user.follow other_user }

    it 'should be followed' do
      expect(user).to be_following(other_user)
    end
  end

  describe '#following' do
    before { user.follow other_user }

    it 'should include other user' do
      expect(user.following).to be_exists(other_user.id)
    end
  end

  describe '#followed_by?' do
    before { other_user.follow user }

    it 'should be followed by other user' do
      expect(user).to be_followed_by(other_user)
    end
  end

  describe '#followers' do
    before { other_user.follow user }

    it 'should include other user' do
      expect(user.followers).to be_exists(other_user.id)
    end
  end
end
