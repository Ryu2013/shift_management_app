RSpec.configure do |config|
  # ActiveJob::TestHelper の perform_enqueued_jobs を使えるようにする
  config.include ActiveJob::TestHelper

  # system specs の実行中は enqueue されたジョブを同期実行する
  # → CI 環境で deliver_later 等の非同期差分によるタイミング問題を減らす
  config.around(:each, type: :system) do |example|
    perform_enqueued_jobs do
      example.run
    end
  end
end
