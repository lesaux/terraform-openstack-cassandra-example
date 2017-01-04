# default: off
# description: Forward connections to the jmx port.
service jmx-from-outside
{
    disable         = no
    socket_type     = stream
    type            = UNLISTED
    wait            = no
    user            = nobody
    bind            = ${bind}
    port            = 7199
    redirect        = 127.0.0.1 7199
}
#
