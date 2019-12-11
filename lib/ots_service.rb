require "ots_service/message"
require "ots_service/secret"
require "ots_service/version"

module OtsService
  class OtsError < StandardError; end
  class MissingPassphraseError < OtsError; end
end
