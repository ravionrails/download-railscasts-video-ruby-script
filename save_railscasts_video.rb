require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'progressbar'

puts "wait".ljust(100, '*')

  puts "enter episode no:"
  episode_no = gets.chomp
    
  puts "Do you want to download Episode: #{episode_no} "
	nokogiri_doc = Nokogiri::HTML(open("http://railscasts.com/episodes/#{episode_no}"))
  
	if nokogiri_doc.css('ul.downloads li a').to_a.map{|a| a.content}.include?('mp4')
    downloadable_link = nokogiri_doc.css('ul.downloads li a').to_a[1]["href"]
		puts "Yippy , mp4 format available to download"
		puts "and downloadable link => #{ downloadable_link }"
		File.open("#{downloadable_link.split('/').last}", "wb") do |file|
      begin
        pbar = nil
        file.write( open(downloadable_link, 
          :content_length_proc => lambda {|t|
            file_size = t
            file_size_in_mb = t/1048576
            puts "File Size : #{file_size_in_mb} MB"
            pbar = ProgressBar.new('Downloading ', file_size) if t && 0 < t
            pbar.file_transfer_mode
          }, 
          :progress_proc => lambda {|s|
            pbar.set s if pbar
          }).read )
      rescue Exception => e
        puts e.message  
        puts e.backtrace.inspect 
      end
		end
    puts ""
	else
		puts "no video found to download, it's a pro episode".center(100, '*')
	end
