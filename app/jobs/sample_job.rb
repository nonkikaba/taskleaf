class SampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Sidekiqのログにメッセージを表示させる
    Sidekiq::logging.logger.info "サンプルジョブを実行しました"
  end
end
