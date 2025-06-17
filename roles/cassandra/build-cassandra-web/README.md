## Environment
Rocky Linux 9.x


## Build Cassandra Web

```sh
git clone https://github.com/avalanche123/cassandra-web
```

```sh
$ dnf install -y gem
```

```sh
$ gem install cassandra-web
Fetching rack-1.6.13.gem
Successfully installed rack-1.6.13
Fetching eventmachine-1.2.7.gem
Building native extensions. This could take a while...
ERROR:  Error installing cassandra-web:
        ERROR: Failed to build gem native extension.

    current directory: /usr/local/share/gems/gems/eventmachine-1.2.7/ext
/usr/bin/ruby -I /usr/share/rubygems -r ./siteconf20250406-2656-cjr8c7.rb extconf.rb
mkmf.rb can't find header files for ruby at /usr/share/include/ruby.h

You might have to install separate package for the ruby development
environment, ruby-dev or ruby-devel for example.

extconf failed, exit code 1

Gem files will remain installed in /usr/local/share/gems/gems/eventmachine-1.2.7 for inspection.
Results logged to /usr/local/lib64/gems/ruby/eventmachine-1.2.7/gem_make.out
```

```sh
$ dnf install ruby-devel
```

```sh
$ gem install cassandra-web
Building native extensions. This could take a while...
Successfully installed eventmachine-1.2.7
Fetching daemons-1.4.1.gem
Successfully installed daemons-1.4.1
~~ snip
Parsing documentation for cassandra-web-0.5.0
Installing ri documentation for cassandra-web-0.5.0
Done installing documentation for eventmachine, daemons, thin, tilt, rack-protection, sinatra, rack-parser, rack-cors, lz4-ruby, ione, cassandra-driver, cassandra-web after 190 seconds
12 gems installed
```

``` sh
$ cassandra-web
<internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:85:in `require': cannot load such file -- bundler/setup (LoadError)
        from <internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from /usr/local/share/gems/gems/cassandra-web-0.5.0/app.rb:6:in `<top (required)>'
        from <internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from <internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from /usr/local/share/gems/gems/cassandra-web-0.5.0/bin/cassandra-web:46:in `run'
        from /usr/local/share/gems/gems/cassandra-web-0.5.0/bin/cassandra-web:104:in `<top (required)>'
        from /usr/local/bin/cassandra-web:25:in `load'
        from /usr/local/bin/cassandra-web:25:in `<main>'
```


``` sh
$ gem install bundler
Fetching bundler-2.5.23.gem
Successfully installed bundler-2.5.23
Parsing documentation for bundler-2.5.23
Installing ri documentation for bundler-2.5.23
Done installing documentation for bundler after 0 seconds
1 gem installed
```

``` sh
$ gem install setup
Fetching setup-5.2.0.gem
Successfully installed setup-5.2.0
Parsing documentation for setup-5.2.0
Installing ri documentation for setup-5.2.0
Done installing documentation for setup after 0 seconds
1 gem installed
```

``` sh
$ cassandra-web
<internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:85:in `require': cannot load such file -- bundler/setup (LoadError)
        from <internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from /usr/local/share/gems/gems/cassandra-web-0.5.0/app.rb:6:in `<top (required)>'
        from <internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from <internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from /usr/local/share/gems/gems/cassandra-web-0.5.0/bin/cassandra-web:46:in `run'
        from /usr/local/share/gems/gems/cassandra-web-0.5.0/bin/cassandra-web:104:in `<top (required)>'
        from /usr/local/bin/cassandra-web:25:in `load'
        from /usr/local/bin/cassandra-web:25:in `<main>'
```

```sh
$ gem install bundler -v 1.0.10
Fetching bundler-1.0.10.gem
Successfully installed bundler-1.0.10
Parsing documentation for bundler-1.0.10
Installing ri documentation for bundler-1.0.10
Done installing documentation for bundler after 0 seconds
1 gem installed
```


```sh
$ cassandra-web
NoMethodError: undefined method `source_index' for Gem:Module
Did you mean?  sources

Usage: cassandra-web [options]
    -B, --bind BIND                  ip:port or path for cassandra web to bind on (default: 0.0.0.0:3000)
    -H, --hosts HOSTS                coma-separated list of cassandra hosts (default: 127.0.0.1)
    -P, --port PORT                  integer port that cassandra is running on (default: 9042)
    -L, --log-level LEVEL            log level (default: info)
    -u, --username USER              username to use when connecting to cassandra
    -p, --password PASS              password to use when connecting to cassandra
    -C, --compression NAME           compression algorithm to use (lz4 or snappy)
        --server-cert PATH           server ceritificate pathname
        --client-cert PATH           client ceritificate pathname
        --private-key PATH           path to private key
        --passphrase SECRET          passphrase for the private key
    -h, --help                       Show help
```


```sh
$ gem install sources
Fetching sources-0.0.1.gem
Successfully installed sources-0.0.1
Parsing documentation for sources-0.0.1
Installing ri documentation for sources-0.0.1
Done installing documentation for sources after 0 seconds
1 gem installed
```


```sh
$ cassandra-web
NoMethodError: undefined method `source_index' for Gem:Module
Did you mean?  sources

Usage: cassandra-web [options]
    -B, --bind BIND                  ip:port or path for cassandra web to bind on (default: 0.0.0.0:3000)
    -H, --hosts HOSTS                coma-separated list of cassandra hosts (default: 127.0.0.1)
    -P, --port PORT                  integer port that cassandra is running on (default: 9042)
    -L, --log-level LEVEL            log level (default: info)
    -u, --username USER              username to use when connecting to cassandra
    -p, --password PASS              password to use when connecting to cassandra
    -C, --compression NAME           compression algorithm to use (lz4 or snappy)
        --server-cert PATH           server ceritificate pathname
        --client-cert PATH           client ceritificate pathname
        --private-key PATH           path to private key
        --passphrase SECRET          passphrase for the private key
    -h, --help                       Show help
```


```sh
[root@rk9-node01 cassandra-web]# gem install rails
Fetching zeitwerk-2.6.18.gem
Successfully installed zeitwerk-2.6.18
Fetching thor-1.3.2.gem
Successfully installed thor-1.3.2
Fetching rake-13.2.1.gem
Successfully installed rake-13.2.1
Fetching rack-3.1.12.gem
Successfully installed rack-3.1.12
Fetching rackup-2.2.1.gem
rackup's executable "rackup" conflicts with rack
Overwrite the executable? [yN]  y
Successfully installed rackup-2.2.1
Fetching io-console-0.8.0.gem
Building native extensions. This could take a while...
Successfully installed io-console-0.8.0
Fetching reline-0.6.1.gem
Successfully installed reline-0.6.1
Fetching stringio-3.1.6.gem
Building native extensions. This could take a while...
Successfully installed stringio-3.1.6
Fetching date-3.4.1.gem
Building native extensions. This could take a while...
Successfully installed date-3.4.1
Fetching psych-5.2.3.gem
Building native extensions. This could take a while...
ERROR:  Error installing rails:
        ERROR: Failed to build gem native extension.

    current directory: /usr/local/share/gems/gems/psych-5.2.3/ext/psych
/usr/bin/ruby -I /usr/share/rubygems -r ./siteconf20250406-3476-llqxqz.rb extconf.rb
checking for yaml.h... no
yaml.h not found
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of necessary
libraries and/or headers.  Check the mkmf.log file for more details.  You may
need configuration options.

Provided configuration options:
        --with-opt-dir
        --without-opt-dir
        --with-opt-include
        --without-opt-include=${opt-dir}/include
        --with-opt-lib
        --without-opt-lib=${opt-dir}/lib64
        --with-make-prog
        --without-make-prog
        --srcdir=.
        --curdir
        --ruby=/usr/bin/$(RUBY_BASE_NAME)
        --with-libyaml-source-dir
        --without-libyaml-source-dir
        --with-yaml-0.1-config
        --without-yaml-0.1-config
        --with-pkg-config
        --without-pkg-config
        --with-libyaml-dir
        --without-libyaml-dir
        --with-libyaml-include
        --without-libyaml-include=${libyaml-dir}/include
        --with-libyaml-lib
        --without-libyaml-lib=${libyaml-dir}/lib64

To see why this extension failed to compile, please check the mkmf.log which can be found here:

  /usr/local/lib64/gems/ruby/psych-5.2.3/mkmf.log

extconf failed, exit code 1

Gem files will remain installed in /usr/local/share/gems/gems/psych-5.2.3 for inspection.
Results logged to /usr/local/lib64/gems/ruby/psych-5.2.3/gem_make.out
```


```sh
$ dnf install libyaml-devel
```


```sh
$ gem install rails
~~ snip
Installing ri documentation for nio4r-2.7.4
Parsing documentation for actioncable-7.1.5.1
Installing ri documentation for actioncable-7.1.5.1
Parsing documentation for rails-7.1.5.1
Installing ri documentation for rails-7.1.5.1
Done installing documentation for psych, rdoc, prettyprint, pp, irb, concurrent-ruby, tzinfo, securerandom, mutex_m, minitest, logger, i18n, drb, connection_pool, bigdecimal, benchmark, base64, activesupport, racc, nokogiri, crass, loofah, rails-html-sanitizer, rails-dom-testing, rack-test, rack-session, erubi, builder, actionview, actionpack, railties, marcel, timeout, activemodel, activerecord, globalid, activejob, activestorage, actiontext, net-protocol, net-smtp, net-pop, net-imap, mini_mime, mail, actionmailer, actionmailbox, websocket-extensions, websocket-driver, nio4r, actioncable, rails after 37 seconds
52 gems installed
```


```sh
$ cassandra-web
NoMethodError: undefined method `source_index' for Gem:Module
Did you mean?  sources

Usage: cassandra-web [options]
    -B, --bind BIND                  ip:port or path for cassandra web to bind on (default: 0.0.0.0:3000)
    -H, --hosts HOSTS                coma-separated list of cassandra hosts (default: 127.0.0.1)
    -P, --port PORT                  integer port that cassandra is running on (default: 9042)
    -L, --log-level LEVEL            log level (default: info)
    -u, --username USER              username to use when connecting to cassandra
    -p, --password PASS              password to use when connecting to cassandra
    -C, --compression NAME           compression algorithm to use (lz4 or snappy)
        --server-cert PATH           server ceritificate pathname
        --client-cert PATH           client ceritificate pathname
        --private-key PATH           path to private key
        --passphrase SECRET          passphrase for the private key
    -h, --help                       Show help
```


# https://stackoverflow.com/questions/15349869/undefined-method-source-index-for-gemmodule-nomethoderror
```sh
$ gem install slimgems
Fetching slimgems-1.3.9.5.gem
Building native extensions. This could take a while...
Upgraded from RubyGems to SlimGems 1.3.9.5
﻿=== 1.3.9.3 / 2011-09-07

SlimGems is a drop-in replacement for RubyGems. See README.md for more.

* Add support for Ruby 1.9.3 preview release (#9)
* Fix rubygems-pwn gem install remote execution vulnerability (#10)

WARN: Unresolved or ambiguous specs during Gem::Specification.reset:
      date (>= 0)
      Available/installed versions of this gem:
      - 3.4.1
      - 3.1.3
WARN: Clearing out unresolved specs. Try 'gem cleanup <gem>'
Please report a bug if this causes problems.
Successfully installed slimgems-1.3.9.5
Parsing documentation for slimgems-1.3.9.5
Installing ri documentation for slimgems-1.3.9.5
Done installing documentation for slimgems after 0 seconds
1 gem installed
```

```sh
$ cassandra-web
/usr/share/ruby/yaml.rb:12: warning: already initialized constant YAML
/usr/local/share/ruby/site_ruby/rubygems/requirement.rb:13: warning: previous definition of YAML was here
/usr/local/bin/cassandra-web:11:in `<main>': undefined method `use_gemdeps' for Gem:Module (NoMethodError)
```


