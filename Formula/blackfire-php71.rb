#encoding: utf-8

require File.expand_path("../../Abstract/abstract-blackfire-php-extension", __FILE__)

class BlackfirePhp71 < AbstractBlackfirePhpExtension
    init
    homepage "https://blackfire.io"
    version '1.20.1'

    url 'http://packages.blackfire.io/homebrew/blackfire-php_1.20.1-darwin_amd64-php71.tar.gz'
    sha256 '586a6a0ff8c6730ea643dc2ad933fd53802e5c43cb61e0c1283d7f4e889026d7'

    def install
        prefix.install "blackfire.so"
        write_config_file
    end

    def config_file
        super + <<~EOS
        blackfire.agent_socket = unix:///usr/local/var/run/blackfire-agent.sock
        blackfire.agent_timeout = 0.25
        ;blackfire.log_level = 3
        ;blackfire.log_file = /tmp/blackfire.log
        ;blackfire.server_id =
        ;blackfire.server_token =
        EOS
    end
end
