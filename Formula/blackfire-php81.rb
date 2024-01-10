#encoding: utf-8

require File.expand_path("../../Abstract/abstract-blackfire-php-extension", __FILE__)

class BlackfirePhp81 < AbstractBlackfirePhpExtension
    init
    homepage "https://blackfire.io"
    version '1.92.7'

    if Hardware::CPU.arm?
        url 'https://packages.blackfire.io/homebrew/blackfire-php_1.92.7-darwin_arm64-php81.tar.gz'
        sha256 '4fd5fe2b106c156b1a6d68adc0495208fe877dd8eb31a290af8e0b1ffade1031'
    else
        url 'https://packages.blackfire.io/homebrew/blackfire-php_1.92.7-darwin_amd64-php81.tar.gz'
        sha256 '0296c403d2a42f56b2867cfeab7f485fcaebd3ac0d68fd49fd331eb93b956b1d'
    end

    def install
        check_php_version
        prefix.install "blackfire.so"
        write_config_file
    end

    def config_file
        if Hardware::CPU.arm?
            agent_socket = 'unix:///opt/homebrew/var/run/blackfire-agent.sock'
        else
            agent_socket = 'unix:///usr/local/var/run/blackfire-agent.sock'
        end

        super + <<~EOS
        blackfire.agent_socket = #{agent_socket}

        ;blackfire.log_level = 3
        ;blackfire.log_file = /tmp/blackfire.log

        ;Sets fine-grained configuration for Probe.
        ;This should be left blank in most cases. For most installs,
        ;the server credentials should only be set in the agent.
        ;blackfire.server_id =

        ;Sets fine-grained configuration for Probe.
        ;This should be left blank in most cases. For most installs,
        ;the server credentials should only be set in the agent.
        ;blackfire.server_token =

        ;Enables Blackfire Monitoring
        ;Enabled by default since version 1.61.0
        ;blackfire.apm_enabled = 1
        EOS
    end
end
