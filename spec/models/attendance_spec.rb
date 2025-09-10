require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe '打刻ボタンの押下順に関するバリデーション' do
    context 'ファクトリで作成したデータを使用する時' do
      it '有効な勤怠記録であること' do
        expect(FactoryBot.build(:attendance)).to be_valid
      end
    end

    context '出勤時間と退勤時間のみを記録したデータを使用する時' do
      let(:attendance) { FactoryBot.build(:attendance, start_rest_time: nil, finish_rest_time: nil) }
      it '有効な勤怠記録であること' do
        expect(attendance).to be_valid
      end
    end

    context '退勤時間が出勤時間より前の場合' do
      let(:attendance) { FactoryBot.build(:attendance, start_time: Time.zone.local(2025, 9, 1, 18, 0), finish_time: Time.zone.local(2025, 9, 1, 9, 0)) }
      it '退勤時間について無効な勤怠記録であること' do
        attendance.valid?
        expect(attendance.errors[:finish_time]).to include('は出勤時間より後に設定してください。')
      end
    end

    context '休憩終了時間が休憩開始時間より前の場合' do
      let(:attendance) { FactoryBot.build(:attendance, start_rest_time: Time.zone.local(2025, 9, 1, 13, 0), finish_rest_time: Time.zone.local(2025, 9, 1, 12, 0)) }
      it '休憩終了時間について無効な勤怠記録であること' do
        attendance.valid?
        expect(attendance.errors[:finish_rest_time]).to include('は休憩開始時間より後に設定してください。')
      end
    end

    context '休憩開始時間が出勤時間より前の場合' do
      let(:attendance) { FactoryBot.build(:attendance, start_time: Time.zone.local(2025, 9, 1, 9, 0), start_rest_time: Time.zone.local(2025, 9, 1, 8, 0)) }
      it '休憩開始時間について無効な勤怠記録であること' do
        attendance.valid?
        expect(attendance.errors[:start_rest_time]).to include('は出勤時間より後に設定してください。')
      end
    end

    context '休憩終了時間が退勤時間より後の場合' do
      let(:attendance) { FactoryBot.build(:attendance, finish_time: Time.zone.local(2025, 9, 1, 18, 0), finish_rest_time: Time.zone.local(2025, 9, 1, 19, 0)) }
      it '休憩終了時間について無効な勤怠記録であること' do
        attendance.valid?
        expect(attendance.errors[:base]).to include('休憩時間は勤務時間内に収める必要があります。')
      end
    end
  end
  describe '打刻ボタンのユニーク制約に関するバリデーション' do
    
    context 'すでに同日に打刻記録がある時に、さらに打刻を記録する場合' do
      let(:user) { FactoryBot.create(:user) }
      
      before do
        FactoryBot.create(:attendance, user: user, date: Date.new(2025, 9, 1))
      end

      it '打刻日について無効であること' do
        duplicate_attendance = FactoryBot.build(:attendance, user: user, date: Date.new(2025, 9, 1))
        expect(duplicate_attendance).to be_invalid  
        duplicate_attendance.valid?
        expect(duplicate_attendance.errors[:date]).to include('は1日に1回しか登録できません。')
      end
    end
  end

end
