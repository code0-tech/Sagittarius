# frozen_string_literal: true

module GrpcHandler
  include Sagittarius::Loggable

  def self.included(base)
    GrpcHandler.handlers << base
    logger.info(message: 'Added handler', handler: base)
  end

  def self.register_on_server(server)
    GrpcHandler.handlers.each do |handler|
      server.handle(handler)
      GrpcHandler.logger.info(message: 'Added handler to GRPC server', handler: handler)
    end
  end

  mattr_accessor :handlers
  GrpcHandler.handlers = []
end
