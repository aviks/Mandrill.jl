module Mandrill
using Requests
using JSON
using Compat

if VERSION < v"0.4.0"
	Base.split(str, spl; limit=0, keep=true) = split(str, spl, limit, keep)
end

global const api = "https://mandrillapp.com/api/1.0"
# package code goes here
function __init__()
  global mandrill_key = get(ENV, "MANDRILL_KEY", "")
end

function key()
  if !isdefined(Mandrill, :mandrill_key) || isempty(mandrill_key)
      error("""API Key not provided
                   Please define MANDRILL_KEY as an environment variable
                   Or call Mandrill.key(k) before using any other function""")
  else
    return mandrill_key::ASCIIString
  end
end

key(k::ASCIIString) = global mandrill_key = k

macro mandrill_api(endpoint)
  splt = split(string(endpoint), '/'; keep=false)
  @assert size(splt, 1) == 2
  fn = symbol(string(splt[1], "_", splt[2]))
  d = quote
    function $(esc(fn))(req=Dict{ASCIIString, Any}())
      mandrill_api_request($(string(api, endpoint)), req)
    end
  end
end

function mandrill_api_request{T <: AbstractString, S <:Any}(endpoint, req::Dict{T,S})
  req["key"] = key()
  res = Requests.post(URI(endpoint), JSON.json(req))
  if res.status == 200
    return Requests.json(res)
  else
    mandrill_error(Requests.json(res))
  end
end

function mandrill_error(res::Dict)
  error("""Mandrill API $(res["status"])
  $(res["code"]): $(res["name"])
  $(res["message"])""")
end

@mandrill_api "/users/ping2"
@mandrill_api "/users/info"
@mandrill_api "/users/senders"
@mandrill_api "/messages/send"
@mandrill_api "/messages/send-template"
@mandrill_api "/messages/search"
@mandrill_api "/messages/search-time-series"
@mandrill_api "/messages/info"
@mandrill_api "/messages/content"
@mandrill_api "/messages/parse"
@mandrill_api "/messages/send-raw"
@mandrill_api "/messages/list-scheduled"
@mandrill_api "/messages/cancel-scheduled"
@mandrill_api "/messages/reschedule"
@mandrill_api "/tags/list"
@mandrill_api "/tags/delete"
@mandrill_api "/tags/info"
@mandrill_api "/tags/time-series"
@mandrill_api "/tags/all-time-series"
@mandrill_api "/rejects/add"
@mandrill_api "/rejects/list"
@mandrill_api "/rejects/delete"
@mandrill_api "/whitelists/add"
@mandrill_api "/whitelists/list"
@mandrill_api "/whitelists/delete"
@mandrill_api "/senders/list"
@mandrill_api "/senders/domains"
@mandrill_api "/senders/add-domain"
@mandrill_api "/senders/check-domain"
@mandrill_api "/senders/verify-domain"
@mandrill_api "/senders/info"
@mandrill_api "/senders/time-series"
@mandrill_api "/urls/list"
@mandrill_api "/urls/search"
@mandrill_api "/urls/time-series"
@mandrill_api "/urls/tracking-domains"
@mandrill_api "/urls/add-tracking-domain"
@mandrill_api "/urls/check-tracking-domain"
@mandrill_api "/templates/add"
@mandrill_api "/templates/info"
@mandrill_api "/templates/update"
@mandrill_api "/templates/publish"
@mandrill_api "/templates/delete"
@mandrill_api "/templates/list"
@mandrill_api "/templates/time-series"
@mandrill_api "/templates/render"
@mandrill_api "/webhooks/list"
@mandrill_api "/webhooks/add"
@mandrill_api "/webhooks/info"
@mandrill_api "/webhooks/update"
@mandrill_api "/webhooks/delete"
@mandrill_api "/subaccounts/list"
@mandrill_api "/subaccounts/add"
@mandrill_api "/subaccounts/info"
@mandrill_api "/subaccounts/update"
@mandrill_api "/subaccounts/delete"
@mandrill_api "/subaccounts/pause"
@mandrill_api "/subaccounts/resume"
@mandrill_api "/inbound/domains"
@mandrill_api "/inbound/add-domain"
@mandrill_api "/inbound/check-domain"
@mandrill_api "/inbound/delete-domain"
@mandrill_api "/inbound/routes"
@mandrill_api "/inbound/add-route"
@mandrill_api "/inbound/update-route"
@mandrill_api "/inbound/delete-route"
@mandrill_api "/inbound/send-raw"
@mandrill_api "/exports/info"
@mandrill_api "/exports/list"
@mandrill_api "/exports/rejects"
@mandrill_api "/exports/whitelist"
@mandrill_api "/exports/activity"
@mandrill_api "/ips/list"
@mandrill_api "/ips/info"
@mandrill_api "/ips/provision"
@mandrill_api "/ips/start-warmup"
@mandrill_api "/ips/cancel-warmup"
@mandrill_api "/ips/set-pool"
@mandrill_api "/ips/delete"
@mandrill_api "/ips/list-pools"
@mandrill_api "/ips/pool-info"
@mandrill_api "/ips/create-pool"
@mandrill_api "/ips/delete-pool"
@mandrill_api "/ips/check-custom-dns"
@mandrill_api "/ips/set-custom-dns"
@mandrill_api "/metadata/list"
@mandrill_api "/metadata/add"
@mandrill_api "/metadata/update"
@mandrill_api "/metadata/delete"


end # module
