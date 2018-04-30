RSpec.describe Resque::Scheduler::RollingRestart do
  it "has a version number" do
    expect(Resque::Scheduler::RollingRestart::VERSION).not_to be nil
  end

  describe 'not master' do
    context 'when boot that there is master already' do
      it 'be not master' do
        skip
      end

      it 'do not enqueue' do
        skip
      end
    end
    context 'when master got term signale' do
      it 'promote to master' do
        skip
      end
    end

    context 'when got term signale' do
      it 'exit myself shortly' do
        skip
      end
    end
  end

  describe 'master' do
    context 'when boot' do
      it 'be master' do
        skip
      end

      it 'do enqueue' do
        skip
      end
    end

    context 'when got term signale' do
      it 'demote to not master' do
        skip
      end

      it 'change to status of waiting_for_next_master' do
        skip
      end

      it 'continue to queue' do
        skip
      end

      context 'when found next master' do
        it 'exit myself shortly' do
          skip
        end
      end
    end
  end
end
