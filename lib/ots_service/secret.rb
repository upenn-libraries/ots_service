require 'net/http'
require 'json'
require 'onetime/api'

require 'pry'

module OtsService
  class Secret

    def generate_secret(options = {})
      secret_message = ''
      url = "https://passwordwolf.com/api/?length=25&upper=on&lower=on&special=on&exclude=012345&repeat=1"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      JSON.parse(response).each do |resp|
        resp.each do |key, value|
          secret_message << "#{key}:\n #{value}\n\n"
        end
      end
      return secret_message
    end

    def generate_ots_url(secret, options)
      api = Onetime::API.new ENV['OTS_EMAIL'], ENV['OTS_APIKEY']
      unless options[:expiration].nil?
        options[:ttl] = options[:expiration] * 24 * 60 * 60
      end
      unless options[:passphrase_hint].nil?
        puts "Enter passphrase:"
        passphrase = gets.chomp!
        options[:passphrase] = passphrase
      end
      options[:secret] = secret
      ret = api.post("/share", options)
      # Ugh, better way to handle this?
      raise MissingPassphraseError if ret[:passphrase_required] == true && options[:passphrase].nil?
      return "https://onetimesecret.com/secret/#{ret[:secret_key]}"
    end



  end
end