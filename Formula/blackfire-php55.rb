require File.expand_path("../../Abstract/abstract-blackfire-php-extension", __FILE__)

class BlackfirePhp55 < AbstractBlackfirePhpExtension
    init
    homepage "https://blackfire.io"
    version '0.19.0'

    url 'http://packages.blackfire.io/homebrew/blackfire-php_0.19.0-darwin_amd64-php55.tar.gz'
    sha1 '8f733cf6cf41624700e5e58a8272236cf944cbcd'

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