RSpec.describe OtsService do
  it "has a version number" do
    expect(OtsService::VERSION).not_to be nil
  end

  it "generates a secret payload" do
    payload = OtsService::Secret.new.generate_secret
    expect(payload).not_to be nil
  end

  it "returns an OTS URL" do
    ots_secret = OtsService::Secret.new
    payload = ots_secret.generate_secret
    options = {}
    url = ots_secret.generate_ots_url(payload, options)
    expect(url).to start_with("https://onetimesecret.com")
  end

  it "sets a passphrase on the OTS secret if specified" do
    ots_secret = OtsService::Secret.new
    secret = "secret_payload"
    options = {:passphrase => "orange"}
    url = ots_secret.generate_ots_url(secret, options)
  end

  it "returns a message" do
    messanger = OtsService::Message.new
    message = messanger.print_template("placeholder","")
    expect(message).not_to be nil
  end

  it "returns a message with expiration information if specified" do
    messanger = OtsService::Message.new
    message = messanger.print_template("expiration_placeholder",
                                       "",
                                       options = {:expiration => "12"})
    expect(message).to include "This link is good for"
  end

  it "returns a message with a passphrase hint if specified" do
    messanger = OtsService::Message.new
    message = messanger.print_template("passphrase_hint_placeholder",
                                       "",
                                       options = {:passphrase_hint => "your favorite color"})
    expect(message).to include "The passphrase to unlock it is"
  end

end
