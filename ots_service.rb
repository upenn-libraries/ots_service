#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'onetime/api'

def generate_secret
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
  return "https://onetimesecret.com/secret/#{ret[:secret_key]}"
end

def email_template(service, ots_url, options = {})
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

options = {}

puts "Enter name of the service for which you are creating a login:"

service_name = gets.chomp!

puts "Enter username:"

options[:username] = gets.chomp!

puts "Setting expiration? (Y/N)"

expiry_bool = gets.chomp!

if expiry_bool[0].downcase == 'y'
  puts "Enter number of days before link expiration:"
  options[:expiration] = gets.chomp!
elsif expiry_bool[0].downcase == 'n'
  puts 'No link expiration'
else
  raise "Invalid input (Y or N expected)"
end

puts "Setting passphrase to unlock secret? (Y/N)"

passphrase_bool = gets.chomp!

if passphrase_bool[0].downcase == 'y'
  puts "Enter the passphrase hint for this link (not the explicit passphrase):"
  options[:passphrase_hint] = gets.chomp!
elsif passphrase_bool[0].downcase == 'n'
  puts 'No passphrase'
else
  raise "Invalid input (Y or N expected)"
end

ots_url = generate_ots_url(generate_secret, options)
email_output = email_template(service_name, ots_url, options)

puts email_output