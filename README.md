_I do not use Mandrill any more, after they changed their subscription models. Therefore, this package is currently unmaintained. I'll be happy to take PR's if anyone is interested._

# A Julia package for the Mandrill REST API

[![Build Status](https://travis-ci.org/aviks/Mandrill.jl.svg?branch=master)](https://travis-ci.org/aviks/Mandrill.jl)

[Mandrill](https://mandrill.com/) is a mail delivery provider for transactional email, created by the folks at
[Mailchimp](https://mailchimp.com). This package is a low overhead, lightweight wrapper around
Mandrill's REST api.

[Mandrill's REST API](https://mandrillapp.com/api/docs/) uses JSON messages to send emails, setup templates, or query reports. To use this package, create the input message as a Julia Dictionary, using the schema in the [Mandrill API Documentation](https://mandrillapp.com/api/docs/). Then, call the corresponding julia method. The call results are returned as JSON documents from Mandrill, which are converted Julia Dictionaries.

Any errors from the API call will result in a Julia `ErrorException` being thrown. This will exit the process if not caught.

Each API endpoint corresponds to a single method. Mandrill API endpoints are structured as `group/name.ext`. This is mapped as a `Mandrill.group_name` method in Julia. For example, the endpoint `/user/info.json` is mapped to the method `Mandril.user_info()`. These methods typically take a Julia Dictionary as their only arguments. For endpoints that do not need any inputs (other than the authentication key,) the method can be called without arguments.

The Mandrill authentication key can be provided via a SHELL environment variable `MANDRILL_KEY` (which must be set before the package is loaded) or explicitly set via the `Mandrill.key(key_string)` method call. The key need not be provided again for each method call.

Note that email attachments are sent as `base64` encoded strings in the Mandrill JSON API. Julia base library includes a `base64encode` method that can be used for this purpose.

## Installation
```julia
Pkg.add("Mandrill")
```

## Example Usage
```julia
using Mandrill
Mandrill.key("axfGadhf4E....")

Mandrill.user_info()
#Dict{AbstractString,Any} with 7 entries:
#  "public_id"    => "WBdNPiLFZ............."
#  "created_at"   => "2015-11-02 14:15:30.37005"
#  "hourly_quota" => 25
#  "username"     => "avik........"
#  "reputation"   => 0
#  "backlog"      => 0
#  "stats"        => Dict{AbstractString,Any}("today"=>Dict{AbstractString,Any}("hard_bounces"=>0,"unique_op…
```
To send a message, it may be simplest to create a `Dict` inline:
```julia
s = Dict(
  "message" => Dict(
    "html" => "<p> Example HTML Content </p>",
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
#stick a @compat in front of Dict creation for julia 0.3

Mandrill.messages_send(s)
#1-element Array{Any,1}:
# Dict{AbstractString,Any}("_id"=>"85115b2d653748e19a37cd851b0fd1d2","status"=>"sent",
#                      "reject_reason"=>nothing,"email"=>"recipient.email@example.com")
```

Alternatively, you could create the Dict piecemeal.

```julia
s = Dict{String, Any}()
message = Dict{String, Any}()
message["html"] = "<p>Example HTML Content</p>"
message["text"] = "Example text content"
message["subject"] = "message.from@example.com"
rcpt1 = Dict{String, Any}()
rcpt1["email"] = "rcpt1@example.com"
rcpt1["name"] = "Recipient One"
rcpt1["type"] = "to"
rcpt2 = Dict{String, Any}()
rcpt2["email"] = "rcpt2@example.com"
rcpt2["name"] = "Recipient Two"
rcpt2["type"] = "cc"
message["to"] = [rcpt1, rcpt2]
s["message"]=message
s["async"] = true

Mandrill.messages_send(s)
#2-element Array{Any,1}:
# Dict{AbstractString,Any}("_id"=>"59b5a7b930b44a21953ae7975c657fcf",
#                    "status"=>"queued","email"=>"rcpt1@example.com")
# Dict{AbstractString,Any}("_id"=>"2dd208db6ad546dfae8a3a2466137260",
#                    "status"=>"queued","email"=>"rcpt2@example.com")
```
