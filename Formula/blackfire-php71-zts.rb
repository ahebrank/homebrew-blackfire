#encoding: utf-8

require File.expand_path("../../Abstract/abstract-blackfire-php-extension", __FILE__)

class BlackfirePhp71Zts < AbstractBlackfirePhpExtension
    init
    homepage "https://blackfire.io"
    version '1.17.1'

    url 'http://packages.blackfire.io/homebrew/blackfire-php_1.17.1-darwin_amd64-php71-zts.tar.gz'
    sha256 'fafd578eeb77512d0914c7ea58e79a5ea47fc720142537c8ac07f4cd6ce4dfde'

    def install
        prefix.install "blackfire.so"
        write_config_file
    end

    def config_file
        super + <<-EOS.undent
        blackfire.agent_socket = unix:///usr/local/var/run/blackfire-agent.sock
        blackfire.agent_timeout = 0.25
        ;blackfire.log_level = 3
        ;blackfire.log_file = /tmp/blackfire.log
        ;blackfire.server_id =
        ;blackfire.server_token =
        EOS
    end
end
