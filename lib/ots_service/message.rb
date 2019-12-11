module OtsService
  class Message
    def print_template(service, ots_url, options = {})
      boilerplate = ''

      boilerplate << "This link is good for #{options[:expiration]} day(s)." unless options[:expiration].nil?
      boilerplate << "The passphrase to unlock it is #{options[:passphrase_hint]}." unless options[:passphrase_hint].nil?
      message = "

Here are the login details for #{service}:

username: #{options[:username]}

You can retrieve your password here:

#{ots_url}

      #{boilerplate}
      "
      return message
    end
  end
end