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

    def self.exec(opts, command)
      if opts.verbose
        print command + "\n"
      end

      `#{command}`

    end

    def self.show(opts,args)

      config = Skull::Config.new
      repoconf = config.read(opts.config)

      idx = 1
      print args.group + "\n"
      args.group.size.times do
        print "-"
      end
      print "\n"
      repoconf.as_h[args.group].as_h["repos"].as_a.each do | repo |
        dest_dir = repo.as_h["source"].as_s.split("/").last.gsub(".git","")
        print idx.to_s + ". " + repo.as_h["source"].as_s + " > " + File.join(repoconf.as_h[args.group].as_h["base_dir"].as_s, dest_dir) + "\n"
        idx += 1
      end

    end

    def self.clone(opts, args)
      config = Skull::Config.new
      repoconf = config.read(opts.config)

      base_dir = repoconf.as_h[args.group].as_h["base_dir"].as_s
      repo_source = repoconf.as_h[args.group].as_h["repos"].as_a[(args.reponr-1)].as_h["source"].as_s

      dest_dir = repo_source.split("/").last.gsub(".git","")
      if repo_source.includes?("@") || repo_source.starts_with?("http")
        command = "git clone " + repo_source + " " + File.join(base_dir, dest_dir)
      else
        command = "git clone git@github.com:" + repo_source + ".git " + File.join(base_dir, dest_dir)
      end

      self.exec(opts, command)
    end

  end

  class Cli < Clim
    main do
      desc "help"
      usage "skull help"
      run do |opts, args|
        puts opts.help_string
      end

      sub "group" do
        desc "show repo's in group, or clone a repo from group"

        option "-v", "--verbose", type: Bool, desc: "Be verbose"
        option "-c /path/to/config.yml", "--config", type: String, desc: "config file to use"

        argument "group",
          desc: "group",
          type: String,
          required: true

        argument "reponr",
        desc: "number of repo to clone, when ommitted the repos will be shown",
          type: Int8,
          required: false,
          default: 0

        usage "skull group [group-name] [repo-nr] [options]"

        run do |opts, args|

          if args.reponr > 0

            Skull::Repo.clone(opts, args)

          else
            Skull::Repo.show(opts,args)
          end

        end
      end

      sub "list" do
        desc "list groups"

        option "-v", "--verbose", type: Bool, desc: "Be verbose"
        option "-c /path/to/config.yml", "--config", type: String, desc: "config file to use"

        usage "skull list [options]"

        run do |opts, args|
          config = Skull::Config.new
          repoconf = config.read(opts.config)

          repoconf.as_h.keys.each do | group |
            print group.as_s + ": " + repoconf.as_h[group.as_s].as_h["base_dir"].as_s + "\n"
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
