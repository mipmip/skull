require "clim"
require "yaml"
require "./skull/*"

WORKAROUND_YAML_UNICODE_BUG = true

module Skull

  class Config

    def read(path)

      homeconf = Path["~/.config/skulls.yaml"].expand(home: true)
      conffile = ""
      if(!path.nil? && File.exists?(path))
        conffile = path
      elsif(File.exists?(homeconf))
        conffile = homeconf
      else
        raise "no config file"
      end

      yaml = File.open(conffile) do |file|
        YAML.parse(file)
      end
    end

  end

  class Repo

  end

  class Cli < Clim
    main do
      desc "help"
      usage "skull help"
      run do |opts, args|
        puts opts.help_string
      end

      sub "clone" do
        desc "clone"

        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "group",
          desc: "group",
          type: String,
          required: false

        argument "reponr",
          desc: "number of repo",
          type: Int8,
          required: true

        argument "path",
          desc: "conf file",
          type: String,
          required: false

        usage "skull clone [GROUP ] [REPO NR] [PATH] [options]"

        run do |opts, args|
          config = Skull::Config.new
          repoconf = config.read(args.path)

          base_dir = repoconf.as_h[args.group].as_h["base_dir"].as_s
          repo_source = repoconf.as_h[args.group].as_h["repos"].as_a[(args.reponr-1)].as_h["source"].as_s
          dest_dir = repo_source.split("/").last.gsub(".git","")

          command = "git clone git@github.com:" + repo_source + ".git " + File.join(base_dir, dest_dir)
          if opts.verbose
            print command + "\n"
          end

          `#{command}`

        end
      end

      sub "show" do
        desc "show conf"

        option "-v", "--verbose", type: Bool, desc: "Be verbose"

        argument "group",
          desc: "group",
          type: String,
          required: false

        argument "path",
          desc: "conf file",
          type: String,
          required: false

        usage "skull show [GROUP ] [PATH] [options]"

        run do |opts, args|
          config = Skull::Config.new
          repoconf = config.read(args.path)

          if args.group.nil?
            idx = 1
            repoconf.as_h.keys.each do | group |
              print idx.to_s + ". " + group.as_s + ": " + repoconf.as_h[group.as_s].as_h["base_dir"].as_s + "\n"
              idx += 1
            end
          else
            idx = 1
            repoconf.as_h[args.group].as_h["repos"].as_a.each do | repo |
              print idx.to_s + ". " + File.join(repoconf.as_h[args.group].as_h["base_dir"].as_s, repo.as_h["source"].as_s) + "\n"
              idx += 1
            end
          end

        end
      end

      sub "version" do
        desc "version"
        usage "skull version"
        run do |opts, args|
          puts Skull::VERSION
        end
      end

    end
  end

end

{% if !@type.has_constant? "TESTING" %}
  Skull::Cli.start(ARGV)
{% end %}
