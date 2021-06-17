# -*- encoding: utf-8 -*-
require 'open-uri'
require 'fileutils'
require 'digest/sha2'
require File.expand_path(File.dirname(__FILE__) + '/parse_csv_and_generate_json')

def main
  download_x_ken_all_csv

  unless File.exists?('tmp/KEN_ALL.CSV')
    raise "tmp/KEN_ALL.CSV not exists"
  end

  new_hash = Digest::SHA256.hexdigest(File.read('tmp/KEN_ALL.CSV'))
  old_hash = Digest::SHA256.hexdigest(File.read('./KEN_ALL.CSV'))

  if new_hash != old_hash
    puts "KEN_ALL.CSV is updated. replace it."
    FileUtils.mv('tmp/KEN_ALL.CSV', './KEN_ALL.CSV')
    puts "generate json file."
    ParseCsvAndGenerateJson.new.main('./KEN_ALL.CSV', './docs')
  else
    puts "KEN_ALL.CSV not updated."
  end
end

def download_x_ken_all_csv
   zip_url = "https://www.post.japanpost.jp/zipcode/dl/oogaki/zip/ken_all.zip"

  system('curl', zip_url, '-o', 'tmp/ken_all.zip')

  unless $?.success?
    raise "curl failed"
  end

  system('unzip', '-o', 'tmp/ken_all.zip', '-d', 'tmp/')
end

case $PROGRAM_NAME
when __FILE__
  main
when /spec[^\/]*$/
  # {spec of the implementation}
end

