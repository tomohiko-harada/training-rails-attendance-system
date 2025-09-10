require 'rails_helper'

# モデルのバリデーションテスト
RSpec.describe User, type: :model do
  context 'ファクトリで作成したデータを使用する時' do
    it '有効なユーザーであること' do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  context 'メールアドレスが無い場合' do
    let(:user) { FactoryBot.build(:user, mail: nil) }

    it '無効であること' do
      user.valid?
      expect(user.errors[:mail]).to include('を入力してください')
    end
  end

  context 'メールアドレスのドメインに.を使わない場合' do
    let(:user) { FactoryBot.build(:user, mail: 'testuser@jmty') }

    it '無効であること' do
      user.valid?
      expect(user.errors[:mail]).to include('は不正な値です')
    end
  end

  context 'メールアドレスが106文字以上の場合' do
    let(:user) { FactoryBot.build(:user, mail: ('a'*101) + ('@a.jp')) }

    it '無効であること' do
      user.valid?
      expect(user.errors[:mail]).to include('は105文字以内で入力してください')
    end
  end

  context '重複したメールアドレスを使用した場合' do
    let(:user1) { FactoryBot.create(:user) }
    let(:user2) { FactoryBot.build(:user, mail: user1.mail) }

    it '無効であること' do
      user2.valid?
      expect(user2.errors[:mail]).to include('はすでに存在します')
    end
  end

  context 'パスワードが無い場合' do
    let(:user) { FactoryBot.build(:user, password: nil) }

    it '無効であること' do
      user.valid?
      expect(user.errors[:password]).to include('を入力してください')
    end
  end

  context 'パスワードが6文字未満の場合' do
    let(:user) { FactoryBot.build(:user, password: 'passw') }

    it '無効であること' do
      user.valid?
      expect(user.errors[:password]).to include('は6文字以上で入力してください')
    end
  end

end