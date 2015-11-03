using Mandrill
using Compat
using Base.Test

# write your own tests here
p = Mandrill.users_ping2()
@test p["PING"] == "PONG!"

p = Mandrill.users_info()
p["public_id"] == "WBdNPiLFZOoKiEZ-stgZOQ"

s = @compat Dict(
  "message" => Dict(
    "html" => "<p> Example HTML Content <p>",
    "text" => "Example Test Content",
    "subject" => "Example Subject",
    "from_email" => "message.from@example.com",
    "from_name" => "Example Name",
    "to" => [
      Dict(
        "email" => "recipient.email@example.com",
        "name" => "Recipient Name",
        "type" => "to"
        )
    ],
    "headers" => Dict(
      "Reply-To" => "message.reply@example.com"
    ),
    "important" => false,
    "tags" => [
      "password-resets",
      "user-initiated"
    ],
    "metadata" => Dict(
      "website" => "www.example.com"
    )
  ),
  "async" => false,
  "ip_pool" => "Main Pool"
)

p=Mandrill.messages_send(s)
@test length(p) == 1
@test p[1]["status"] == "sent"

s = Dict{ASCIIString, Any}()
message = Dict{ASCIIString, Any}()
message["html"] = "<p>Example HTML Content</p>"
message["text"] = "Example text content"
message["subject"] = "message.from@example.com"
rcpt1 = Dict{ASCIIString, Any}()
rcpt1["email"] = "rcpt1@example.com"
rcpt1["name"] = "Recipient One"
rcpt1["type"] = "to"
rcpt2 = Dict{ASCIIString, Any}()
rcpt2["email"] = "rcpt2@example.com"
rcpt2["name"] = "Recipient Two"
rcpt2["type"] = "cc"
message["to"] = [rcpt1, rcpt2]
s["message"]=message
s["async"] = true

p=Mandrill.messages_send(s)
@test length(p) == 2
@test p[1]["status"] == "queued"
@test p[2]["status"] == "queued"
