#encoding: utf-8

require 'formula'

class Blackfire < Formula
    homepage 'https://blackfire.io'
    version '2.21.0'

    if Hardware::CPU.arm?
        url 'https://packages.blackfire.io/blackfire/2.21.0/blackfire-darwin_arm64.pkg.tar.gz'
        sha256 '29ee79252f64624097ebd8713af9cd47a16c304b9f82f35fd5d39a1e7ce5729d'
    else
        url 'https://packages.blackfire.io/blackfire/2.21.0/blackfire-darwin_amd64.pkg.tar.gz'
        sha256 '1806cdd06a168b0d400307e8d417c52b46e8a3e432c1f634542e129528c00caa'
    end

    conflicts_with "blackfire-agent", because: "blackfire replaces the blackfire-agent package"

    def install
        bin.install 'usr/bin/blackfire'
        man1.install 'usr/share/man/man1/blackfire.1.gz'
        sl_etc = etc + 'blackfire'
        sl_etc.mkpath unless sl_etc.exist?
        sl_etc.install 'etc/blackfire/agent.dist'
        FileUtils.cp sl_etc+'agent.dist', sl_etc+'agent' unless File.exists? sl_etc+'agent'

        sl_log = var+'log/blackfire'
        sl_log.mkpath unless sl_log.exist?

        sl_run = var + 'run'
        sl_run.mkpath unless sl_run.exist?

        watchdir = var+'lib/blackfire/traces'
        watchdir.mkpath unless watchdir.exist?
    end

    def plist; <<~EOS
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
                <dict>
                    <key>KeepAlive</key>
                    <true/>
                    <key>Label</key>
                    <string>#{plist_name}</string>
                    <key>ProgramArguments</key>
                    <array>
                        <string>#{bin}/blackfire</string>
                        <string>agent:start</string>
                        <string>--config</string>
                        <string>#{etc}/blackfire/agent</string>
                        <string>--log-file</string>
                        <string>#{var}/log/blackfire/agent.log</string>
                    </array>
                    <key>RunAtLoad</key>
                    <true/>
                    <key>WorkingDirectory</key>
                    <string>#{HOMEBREW_PREFIX}</string>
            </dict>
        </plist>
        EOS
    end

    def caveats
        <<~EOS

        \033[32m✩ ✩ ✩ ✩   Register your Agent  ✩ ✩ ✩ ✩\033[0m

        Before launching the agent, you need to register it by running:

        \033[32mblackfire agent:config\033[0m
        EOS
    end

end
