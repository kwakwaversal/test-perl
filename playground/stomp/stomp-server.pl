#!/usr/bin/env perl

# ABSTRACT: test STOMP v1.1 using `stomp.js` and Mojolicious

use Mojolicious::Lite -signatures;

use Data::UUID::LibUUID;
use Mojo::WebSocket 'WS_CLOSE';
use Net::Stomp::Frame;

get '/' => 'index';

websocket '/ws' => sub ($c) {
    $c->tx->res->headers->sec_websocket_protocol('v11.stomp');

    $c->on(
        frame => sub ($c, $frame) {
            $c->app->log->debug($c->app->dumper($frame));
            my $cmd = Net::Stomp::Frame->parse($frame->[5]);
            $c->app->log->debug($c->app->dumper($cmd));

            if ($frame->[4] == WS_CLOSE) {
                $c->app->log->debug("Client closing connection");
            }
            elsif ($frame->[5] eq "\n") {
                $c->app->log->debug("Received PING");
                $c->send("\n");

               # Sending a newline above is enough to satisfy a PONG response.
               # The following command frame is just to test a subscription
               # using stomp.js.
                my $cf = Net::Stomp::Frame->new(
                    {   command => 'MESSAGE',
                        headers => {
                            'content-type' => 'text/plain',
                            'destination'  => '/queue/a',
                            'subscription' => 'sub-0',
                            'message-id'   => new_uuid_string(),
                        },
                        body => "hi there",
                    }
                );
                $c->send($cf->as_string);
            }
            elsif ($cmd->command eq 'CONNECT') {

                # The first command initiated by a STOMP client
                my $cf = Net::Stomp::Frame->new(
                    {   command => 'CONNECTED',
                        headers =>
                            {version => '1.1', 'heart-beat' => '10000,10000'},
                    }
                );
                $c->send($cf->as_string);
            }
        }
    );
};

app->start;

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head><title>Test</title></head>
  <body>
    %= javascript 'https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js';
    <script language="ignore">
      var url = "ws://" + window.location.host + "/ws";
      var client = Stomp.client(url);

      var connectCallback = function() {
        // called back after the client is connected and authenticated to the STOMP server
        console.log("connected");

        var subscription = client.subscribe("/queue/a", function(message) {
            console.log(message);
            message.ack();
        });
      };

      var errorCallback = function(error) {
        // display the error's message header:
        // console.log(error);
        // alert(error.headers.message);
      };

      client.connect('paul', 'williams', connectCallback, errorCallback);
    </script>
    <script>
      var url = "ws://" + window.location.hostname + ":61614";
      var client = Stomp.client(url);

	  client.debug = function(str) {
		// append the debug log to a #debug div somewhere in the page using JQuery:
		console.log(str + "\n");
	  };

      var connectCallback = function() {
        console.log("connected");

		client.send("/queue/foo", {priority: 9}, "Hello, STOMP");

        var subscription = client.subscribe("/queue/foo", function(message) {
            console.log(message);
            //message.ack();
        });

        var topic = client.subscribe("/topic/foo", function(message) {
            console.log(message);
            message.ack();
        });
      };

      client.connect({}, connectCallback);
    </script>

    You won't see anything useful here. Look in the `console log`.
  </body>
</html>
