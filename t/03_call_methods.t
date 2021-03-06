use strict;
use warnings;
use utf8;
use 5.10.0;

use Test::More;
use t::Util qw/ slack set_any_mock_response /;

my %tests = (
    auth => {
        revoke => {
            test => 1,
        },
        test => +{},
    },
    channels => {
        archive => {
            channel => 'hoge',
        },
        create => {
            name     => 'hoge',
            validate => 1,
        },
        history => {
            channel   => 'hoge',
            count     => 100,
            inclusive => 1,
            latest    => '1234567890.123456',
            oldest    => '1234567890.123456',
            unreads   => 1,
        },
        info => {
            channel => 'hoge',
        },
        invite => {
            channel => 'hoge',
            user    => 'hoge',
        },
        join => {
            name     => 'hoge',
            validate => 1,
        },
        kick => {
            channel => 'hoge',
            user    => 'hoge',
        },
        leave => {
            channel => 'hoge',
        },
        list => {
            cursor           => 'dXNlcjpVMDYxTkZUVDI=',
            exclude_archived => 1,
            exclude_members  => 1,
            limit            => 20,
        },
        mark => {
            channel => 'hoge',
            ts      => '1234567890.123456',
        },
        rename => {
            channel => 'hoge',
            name    => 'hoge',
        },
        replies => {
            channel   => 'hoge',
            thread_ts => '1234567890.123456',
        },
        set_purpose => {
            channel => 'hoge',
            purpose => 'hoge',
        },
        set_topic => {
            channel => 'hoge',
            topic   => 'hoge',
        },
        unarchive => {
            channel => 'hoge',
        },
    },
    chat => {
        delete => {
            channel => 'hoge',
            ts      => '1234567890.123456',
            as_user => 1,
        },
        me_message => {
            channel => 'hoge',
            text    => 'hoge',
        },
        post_ephemeral => {
            channel      => 'hoge',
            text         => 'hoge',
            user         => 'hoge',
            as_user      => 1,
            attachments  => [{hoge => 'fuga'}],
            link_names   => 1,
            parse        => 'hoge',
        },
        post_message => {
            channel         => 'hoge',
            text            => 'hoge',
            as_user         => 1,
            attachments     => [{hoge => 'fuga'}],
            icon_emoji      => ':poop:',
            icon_url        => 'https://hoge',
            link_names      => 1,
            parse           => 'hoge',
            reply_broadcast => 1,
            thread_ts       => '1234567890.123456',
            unfurl_links    => 1,
            unfurl_media    => 1,
            username        => 'hoge',
        },
        unfurl => {
            channel            => 'hoge',
            ts                 => '1234567890.123456',
            unfurls            => 'hoge',
            user_auth_message  => 'hoge',
            user_auth_required => 1,
            user_auth_url      => 'https://hoge',
        },
        update => {
            channel     => 'hoge',
            text        => 'hoge',
            ts          => '1234567890.123456',
            as_user     => 1,
            attachments => [{hoge => 'fuga'}],
            link_names  => 1,
            parse       => 'hoge',
        },
    },
    emoji => {
        list => +{},
    },
    files => {
        delete => {
            file => 'file_id',
        },
        info => {
            file  => 'file_id',
            count => 10,
            page  => 2,
        },
        list => {
            channel => 'hoge',
            count   => 10,
            page    => 2,
            ts_from => '1234567890.123456',
            ts_to   => '1234567890.123456',
            types   => 'image',
            user    => 'user_id',
        },
        revoke_public_url => {
            file => 'file_id',
        },
        shared_public_url => {
            file => 'file_id',
        },
        upload => {
            channels        => ['hoge', 'fuga'],
            content         => 'hoge content',
            file            => __FILE__,       # using this file
            filename        => 'name',
            filetype        => 'type',
            initial_comment => 'initial hoge',
            title           => 'hoge title',
        },
    },
    groups => {
        archive => {
            channel => 'hoge',
        },
        close => {
            channel => 'hoge',
        },
        create => {
            name     => 'hoge',
            validate => 1,
        },
        create_child => {
            channel => 'hoge',
        },
        history => {
            channel   => 'hoge',
            count     => 100,
            inclusive => 1,
            latest    => '1234567890.123456',
            oldest    => '1234567890.123456',
            unreads   => 1,
        },
        info => {
            channel => 'hoge',
        },
        invite => {
            channel => 'hoge',
            user    => 'fuga',
        },
        kick => {
            channel => 'hoge',
            user    => 'fuga',
        },
        leave => {
            channel => 'hoge',
        },
        list => {
            exclude_archived => 1,
            exclude_members  => 1,
        },
        mark => {
            channel => 'hoge',
            ts      => '1234567890.123456',
        },
        open => {
            channel => 'hoge'
        },
        rename => {
            channel => 'hoge',
            name    => 'fuga',
        },
        replies => {
            channel   => 'hoge',
            thread_ts => '1234567890.123456',
        },
        set_purpose => {
            channel => 'hoge',
            purpose => 'fuga',
        },
        set_topic => {
            channel => 'hoge',
            topic   => 'fuga',
        },
        unarchive => {
            channel => 'hoge',
        },
    },
    im => {
        close => {
            channel => 'hoge',
        },
        history => {
            channel   => 'hoge',
            count     => 100,
            inclusive => 1,
            latest    => '1234567890.123456',
            oldest    => '1234567890.123456',
            unreads   => 1,
        },
        list => {
            cursor => 'dXNlcjpVMDYxTkZUVDI=',
            limit  => 20,
        },
        mark => {
            channel => 'hoge',
            ts      => '1234567890.123456',
        },
        open => {
            user      => 'hoge',
            return_im => 1,
        },
        replies => {
            channel   => 'hoge',
            thread_ts => '1234567890.123456',
        },
    },
    oauth => {
        access => {
            client_id     => 'hoge',
            client_secret => 'fuga',
            code          => 'piyo',
            redirect_uri  => 'http://hoge.hoge',
        },
        access => {
            client_id      => 'hoge',
            client_secret  => 'fuga',
            code           => 'piyo',
            redirect_uri   => 'http://hoge.hoge',
            single_channel => 1,
        },
    },
    pins => {
        add => {
            channel      => 'C1234567890',
            file         => 'F1234567890',
            file_comment => 'Fc1234567890',
            timestamp    => '1234567890.123456',
        },
        list => {
            channel => 'C1234567890',
        },
        remove => {
            channel      => 'C1234567890',
            file         => 'F1234567890',
            file_comment => 'Fc1234567890',
            timestamp    => '1234567890.123456',
        },
    },
    reactions => {
        add => {
            name         => 'thumbsup',
            channel      => 'C1234567890',
            file         => 'F1234567890',
            file_comment => 'Fc1234567890',
            timestamp    => '1234567890.123456',
        },
        get => {
            channel      => 'C1234567890',
            file         => 'F1234567890',
            file_comment => 'Fc1234567890',
            full         => 1,
            timestamp    => '1234567890.123456',
        },
        list => {
            count => 10,
            full  => 1,
            page  => 2,
            user  => 'U1234567890',
        },
        remove => {
            name         => 'thumbsup',
            channel      => 'C1234567890',
            file         => 'F1234567890',
            file_comment => 'Fc1234567890',
            timestamp    => '1234567890.123456',
        },
    },
    rtm => {
        connect => {
            batch_presence_aware => 1,
            presence_sub         => 1,
        },
        start => {
            batch_presence_aware => 1,
            mpim_aware           => 1,
            no_latest            => 1,
            no_unreads           => 1,
            presence_sub         => 1,
            simple_latest        => 1,
        },
    },
    search => {
        all => {
            query     => 'hoge',
            count     => 10,
            highlight => 1,
            page      => 2,
            sort      => 'key',
            sort_dir  => 'asc',
        },
        files => {
            query     => 'hoge',
            count     => 10,
            highlight => 1,
            page      => 2,
            sort      => 'key',
            sort_dir  => 'asc',
        },
        messages => {
            query     => 'hoge',
            count     => 10,
            highlight => 1,
            page      => 2,
            sort      => 'key',
            sort_dir  => 'asc',
        },
    },
    stars => {
        add => {
            channel      => 'C1234567890',
            file         => 'F1234567890',
            file_comment => 'Fc1234567890',
            timestamp    => '1234567890.123456',
        },
        list => {
            count => 100,
            page  => 2,
        },
        add => {
            channel      => 'C1234567890',
            file         => 'F1234567890',
            file_comment => 'Fc1234567890',
            timestamp    => '1234567890.123456',
        },
    },
    team => {
        access_logs => {
            before => 1457989166,
            count => 100,
            page  => 2,
        },
        billable_info => {
            user => 'hoge',
        },
        info => +{},
        integration_logs => {
            app_id      => 'hoge',
            change_type => 'add',
            count       => 20,
            page        => 1,
            service_id  => 'hoge',
            user        => 'hoge',
        },
    },
    users => {
        delete_photo => +{},
        get_presence => {
            user => 'hoge',
        },
        identity => +{},
        info => {
            user => 'hoge',
        },
        list => {
            cursor   => 'dXNlcjpVMDYxTkZUVDI=',
            limit    => 100,
            presence => 1,
        },
        set_active => +{},
        set_presence => {
            presence => 'hoge',
        },
    },
);

set_any_mock_response;
my $slack = slack();

while (my ($ns, $methods) = each %tests) {
    subtest $ns => sub {
        while (my ($method, $args) = each %$methods) {
            isa_ok $slack->$ns->$method(%$args), 'HASH', "$method returns HashRef";
        }
    };
}

done_testing;

