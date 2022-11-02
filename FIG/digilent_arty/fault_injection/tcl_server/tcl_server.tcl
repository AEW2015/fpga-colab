package provide tcl_server 0.1.0

namespace eval tcl_server {
    variable socket_instance
    variable connection
    
    proc start_server {{port 8953}} {
        variable socket_instance

        set socket_instance [socket -server tcl_server::ConnAccept $port]
        
        puts "Started Socket Server on port - $port"
    }

    proc ConnAccept {sock addr port} {           # Make a proc to accept connections
        variable connection   
        
        puts "Accept $sock from $addr port $port"
        set connection(addr,$sock) [list $addr $port]    

        fconfigure $sock -buffering line
        fileevent $sock readable [list tcl_server::IncomingCommand $sock]
    }

    proc IncomingCommand {sock} {
        variable connection

        if {[eof $sock] || [catch {gets $sock command}]} {
            close $sock
            puts "Close $connection(addr,$sock)"		
            unset connection(addr,$sock)
        } else {
            catch { linsert [eval $command] end EOF} result
            puts $sock $result
        }
    }
    
    proc stop_server {} {
        variable socket_instance
        
        close $socket_instance
    }
}