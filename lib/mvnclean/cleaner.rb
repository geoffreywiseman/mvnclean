require 'time'
require 'fileutils'

module MavenClean

	class Cleaner

		def initialize( repo, threshold_date, ignore_pattern )
			@repo = repo
			@ignore_folders = [ '.', '..' ]
			@threshold_date = threshold_date
			@threshold_time = threshold_date.to_time
			@candidates = []
			@candidates_size = 0
			@ignore_pattern = ignore_pattern
		end

		def clean()
			if( File.exist?( @repo ) )
				puts "Dependencies older than #{@threshold_date} from repository #{@repo}:"
				scan
				puts
				if @candidates.size == 0 then
					puts "No candidates found."
				else
					puts "Found #{@candidates.size} candidates totalling #{approx_size(@candidates_size)}"
					puts 
					print "Delete these? [y/N]: "
					if delete? gets then
						delete_candidates
					else
						puts
						puts "No deletion performed."
					end
				end
			else
				puts "Can't find repo: #{@repo}"
			end
		end

		private

		# Search for POM files
		def scan( dirname = nil )
			dir_path = get_repo_abs_path( dirname )
			Dir.foreach( dir_path ) do |child|
				child_abs_path = File.join( dir_path, child )
				if File.directory?( child_abs_path ) then
					child_rel_path = get_repo_rel_path( dirname, child )
					scan child_rel_path unless @ignore_folders.include? child
				else
					select_candidates( dirname ) if File.extname( child ) == '.pom' && ! @candidates.include?( dirname )
				end
			end
		end

		# Get the absolute path of a directory within the repo
		def get_repo_abs_path( dirname )
			if dirname == nil then
				@repo
			else
				File.join( @repo, dirname )
			end
		end

		# Get the repo-relative path of a child-directory given its parent (basically a null-safe file.join)
		def get_repo_rel_path( dirname, child )
			if dirname == nil then
				child
			else
				File.join( dirname, child )
			end
		end

		# Consider a Project (as identified by its POM) for Deletion
		def select_candidates( folder )
			mru = get_mru( folder )
			if mru < @threshold_time then
				if !ignore? folder then
					@candidates << folder
					fs = folder_size( folder )
					@candidates_size += fs
					puts "- #{folder} (#{approx_size(fs)})"
				end
			end
		end

		def ignore?( folder )
			folder =~ @ignore_pattern
		end

		# Calculate the size of a folder (the sum of the files it contains)
		def folder_size( dirname )
			path = get_repo_abs_path( dirname )
			paths = Dir.entries( path ).map { |f| File.join path, f }
			files = paths.select{ |x| File.file? x }
			sizes = files.map{ |x| File.size( x ) }
			sizes.reduce :+
		end

		# Get the access time of the most recently used file within the directory.
		def get_mru( dirname )
			mru = nil
			dir_path = File.join( @repo, dirname )
			Dir.foreach( dir_path ) do |child|
				child_path = File.join( dir_path, child )
				if File.file? child_path then
					atime = File.atime( child_path )
					mru = atime if mru == nil || atime > mru
				end
			end
			return mru
		end

		# Get the human-readable version of a size in bytes
		def approx_size( size )
			units = ['PB', 'TB', 'GB', 'MB', 'KB', 'B']
			magnitude = size
			unit = units.pop

			while magnitude > 1000 do
				magnitude /= 1000
				unit = units.pop
			end

			"~#{magnitude}#{unit}"
		end

		# Was the user's response a 'delete'?
		def delete?( response )
			[ 'y', 'yes', 'true' ].include? response.strip.downcase
		end

		# Delete the candidates
		def delete_candidates
			puts "Deleting #{@candidates.size} candidates."
			@candidates.each do |dir|
				FileUtils.remove_entry_secure get_repo_abs_path( dir )
			end
			puts
			puts "Deletion complete."
		end

	end

end