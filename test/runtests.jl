using Mandrill
using Base.Test

# write your own tests here
p = Mandrill.users_ping2()
@test p["PING"] == "PONG!"

p = Mandrill.users_info()
p["public_id"] == "WBdNPiLFZOoKiEZ-stgZOQ"
