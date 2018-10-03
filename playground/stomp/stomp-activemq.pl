#!/usr/bin/env perl

# ABSTRACT: connect to ActiveMQ websocket and subscribe to queue

use Mojo::Base -strict;

use Data::Dumper;
use Mojo::IOLoop;
use Mojo::UserAgent;
use Net::Stomp;
use Net::Stomp::Frame;
use Scalar::Util 'weaken';

# Blocking connection to a STOMP (non-websocket) server.
#
# my $stomp = Net::Stomp->new( { hostname => 'localhost', port => '61613' } );
# my $frame = $stomp->connect( );
# $stomp->subscribe(
#     {   destination             => '/queue/foo',
#         'ack'                   => 'client',
#         'activemq.prefetchSize' => 1
#     }
# );
# while (1) {
#   my $frame = $stomp->receive_frame;
#   if (!defined $frame) {
#     # maybe log connection problems
#     next; # will reconnect automatically
#   }
#   warn $frame->body; # do something here
#   $stomp->ack( { frame => $frame } );
# }
# $stomp->disconnect;

# To get a docker ActiveMQ set up for testing, follow the instructions at
# https://hub.docker.com/r/rmohr/activemq/
#
# docker run -p 61614:61614 -p 61616:61616 -p 61613:61613 -p 8161:8161 -v \
#   $(pwd)/activemq/conf:/opt/activemq/conf -v \
#   $(pwd)/activemq/data:/opt/activemq/data rmohr/activemq:5.15.4-alpine
my $ua = Mojo::UserAgent->new;

$ua->websocket(
    'ws://localhost:61614' => ['v10.stomp', 'v11.stomp'] => sub {
        my ($ua, $tx) = @_;
        say 'WebSocket handshake failed!' and return unless $tx->is_websocket;
	    say 'Subprotocol negotiation failed!' and return unless $tx->protocol;

        $tx->on(
            finish => sub {
                my ($tx, $code, $reason) = @_;
                say "WebSocket closed with status $code.";
            }
        );
        $tx->on(
            message => sub {
                my ($tx, $msg) = @_;

				my $cmd = Net::Stomp::Frame->parse($msg);
				print Dumper($cmd);
                if ($cmd->command eq 'CONNECTED') {
                    my $subscribe = Net::Stomp::Frame->new(
                        {   command => 'SUBSCRIBE',
                            headers => {
                                'destination' => '/queue/foo',
                                'ack'         => 'client'
                            }
                        }
                    );
                    $tx->send($subscribe->as_string);
                }
            }
        );

        my $frame = Net::Stomp::Frame->new(
            {command => 'CONNECT'},
            {   'accept-version' => '1.1,1.0',
                'host'           => 'localhost',
                'heart-beat'     => '10000,10000'
            }
        );
        $tx->send($frame->as_string);

        # PING ActiveMQ every 9 seconds to maintain the connection
        weaken $tx;

        Mojo::IOLoop->recurring(
            9 => sub {
                $tx->send("\n");
            }
        );
    }
);

Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
