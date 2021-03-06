require 'sidekiq-scheduler'
module OmertaLogger
  class ImportScheduler
    include Sidekiq::Worker
    sidekiq_options queue: 'import', retry: 0

    def perform
      unless OmertaLogger.config.respond_to? :domains
        raise 'Please provide initializer file. See test/dummy/config/initializers/omerta_logger.rb.example'
      end
      OmertaLogger.config.domains.each do |domain|
        ImportWorker.perform_async(domain)
      end
    end
  end
end
