require 'optparse'

# Command-Line Interface for MavenClean, dealing with argument parsing, etc.
module MavenClean
	class CommandLineInterface
		def initialize()
			@options = {repo:get_default_repo, months: 6, prune: false}
			@parser = OptionParser.new do |opts|
				opts.banner = "USAGE: mavenclean [options]"
				opts.on( "-r REPO", "--repo REPO", "Specifies the repository folder." ) { |repo| @options[:repo] = repo }
				opts.on( "-m MONTHS", "--months MONTHS", OptionParser::DecimalInteger,
					"Specifies the number of months before which the last-accessed-date of a", 
					"dependency must be in order to be removed.") do |m|
					@options[:months]=m
				end
				opts.on( "-p", "--prune", "Prune empty folders from within the repository." ) { @options[:prune] = true }
				opts.on( "-i PATTERN", "--ignore PATTERN", 
					"A regular expression describing dependencies to ignore (e.g. not ",
					"consider for deletion)." ) do |p|
					begin
						@options[:ignore]=Regexp.new(p)
					rescue
						puts "Invalid pattern: /#{p}/"
						puts
						puts opts
						exit
					end
				end
				opts.on( "-v", "--verbose",
					"Print more verbose information that could be used to diagnose surprising candidates." ) do
					@options[:verbosity]=:verbose
				end
				opts.on_tail( "-?", "--help", "Displays this help message." ) do
					puts opts
					exit
				end
			end
		end

		def parse_config
			@parser.parse!
			@options[:repo] ||= get_default_repo
			@options[:verbosity] ||= :normal
		end

		def config_valid?
			# Check for Repo
			repoOk = File.directory? @options[:repo]
			if !repoOk then
				puts "Repository #{@options[:repo]} not found"
			end

			valid = repoOk
			if !valid then
				puts
				puts @parser
			end

			return valid
		end

		def run
			puts "MavenClean"
			puts "  repo: #{@options[:repo]}" 
			puts "  months: #{@options[:months]}"
			puts "  ignore: #{@options[:ignore].inspect}" unless @options[:ignore] == nil
			puts "  prune empty folders: #{@options[:prune]}"
			puts "  verbosity: #{@options[:verbosity].to_s}"
			puts
			threshold_date = ( Date.today << @options[:months] )
			Cleaner.new( @options[:repo], threshold_date, @options[:ignore], @options[:verbosity], @options[:prune] ).clean
		end

		# Private Methods 
		private

		# Get the Default Repository
		def get_default_repo
			ENV[ "M2_REPO" ] || File.join( Dir.home, ".m2", "repository" )
		end   
	end
end