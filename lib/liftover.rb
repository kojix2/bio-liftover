#!/usr/bin/ruby

# Copyright::   Copyright (C) 2009
#               Andrei Rozanski <rozanski.andrei@gmail.com>
# License::     The Ruby License
# == Description
# This file containts a liftover for Ruby

require 'zlib'
require 'open-uri'
require 'interval-tree'
require_relative 'liftover/version'

module LiftOver
  class Query
    def initilize; end

    # Given a pair of genomes, fetch chain file and parse it into a array.
    def self.parse_chain_file(gen1, gen2, chr_input, coord_start, coord_end, chain_file)
      @chains = []
      @chains_complete = []
      @@gen1 = gen1
      @@gen2 = gen2
      @@chr_input = chr_input
      @@coord_start = coord_start.to_i
      @@coord_end = coord_end.to_i
      if chain_file.nil? # switch between local/remote parse file
        LiftOver::Query.parse_remote_chain
      else
        LiftOver::Query.parse_local_chain
      end
    end # parse_chain_file

    # Retrieve and parse remote chain file from http://hgdownload.cse.ucsc.edu/goldenPath/
    def self.parse_remote_chain
      open("http://hgdownload.cse.ucsc.edu/goldenPath/#{@@gen1}/liftOver/#{@@gen1}To#{@@gen2}.over.chain.gz") do |rmt_file|
        gz = Zlib::GzipReader.new(rmt_file).read
        flag = 0
        header = ''
        coords = []
        result = []
        gz.split("\n").each do |line|
          if line.start_with?('chain')
            qry = LiftOver::Query.search_for_chain_by_interval(line)
            if qry == true
              flag = 1
              header = line
            else
              flag = 0
              if header != ''
                a = { "#{header.chomp}" => coords }
                result.push(a)
              end
              a = ''
              header = ''
              coords = []
            end
          elsif flag == 1
            coords.push(line.chomp.split("\t").map(&:to_i))
          end
        end
        scores = []
        if !result.empty?
          result.each do |hits|
            hits.keys.each do |ev|
              scores.push(ev.split(' ')[1].to_i)
            end
          end
        else
          puts 'Candidate chain not found'
        end
        start_val = ''
        end_val = ''
        res = []
        result.each do |hits|
          start_val = LiftOver::Query.lift(hits, @@coord_start)
          end_val = LiftOver::Query.lift(hits, @@coord_end)
          if hits.keys[0].split(' ')[9] != '-'
            res.push("#{hits.keys[0].split(' ')[7]}:#{start_val}-#{end_val}")
          else
            res.push("#{hits.keys[0].split(' ')[7]}:#{end_val}-#{end_val}")
          end
          start_val = ''
          end_val = ''
        end
        puts res
      end
    rescue SocketError => e
      puts "There's a connection problem with your request.\n Error message: #{e.message}."
    rescue SystemCallError => e
      puts "There's a problem with your request.\n Error message: #{e.message}."
    rescue OpenURI::HTTPError => e
      puts "Couldn't retrieve chain file. Genome names are case sensitive. Please check http://hgdownload.cse.ucsc.edu/goldenPath\n Error message: #{e.message}."
      exit
    end # parse_remote_chain

    # Parse local chain file
    def self.parse_local_chain
      gz_file = open(doc['<chain_file>'])
      gz = Zlib::GzipReader.new(gz_file)
      flag = 0
      header = ''
      coords = []
      result = []
      gz.each_line do |line|
        if line.chomp.start_with?('chain')
          qry = LiftOver::Query.search_for_chain_by_interval(line)
          if qry == true
            flag = 1
            header = line
          else
            flag = 0
            if header != ''
              a = { "#{header.chomp}" => coords }
              result.push(a)
            end
            a = ''
            header = ''
            coords = []
          end
        elsif flag == 1
          coords.push(line.chomp.split("\t").map(&:to_i))
        end
      end
      scores = []
      if !result.empty?
        result.each do |hits|
          hits.keys.each do |ev|
            scores.push(ev.split(' ')[1].to_i)
          end
        end
      else
        puts 'Candidate chain not found'
      end
      start_val = ''
      end_val = ''
      res = []
      result.each do |hits|
        start_val = LiftOver::Query.lift(hits, @@coord_start)
        end_val = LiftOver::Query.lift(hits, @@coord_end)
        if hits.keys[0].split(' ')[9] != '-'
          res.push("#{hits.keys[0].split(' ')[7]}:#{start_val}-#{end_val}")
        else
          res.push("#{hits.keys[0].split(' ')[7]}:#{end_val}-#{end_val}")
        end
        start_val = ''
        end_val = ''
      end
      puts res
    end # parse_local_chain

    # Search for chains that fits on coordinates given to be "lifted"
    def self.search_for_chain_by_interval(string)
      hits = []
      field = string.split(' ')
      return unless @@chr_input == field[2]

      itval = IntervalTree::InclusiveTree.new(field[5].to_i...field[6].to_i)
      res = itval.search(@@coord_start...@@coord_end)
      if !res.nil?
        if !res.empty?
          true
        else
          false
        end
      else
        false
      end
    end # search_for_chain_by_interval

    # Lift coordinates
    def self.lift(array, coordinate)
      res_chr = ''
      res_start = ''
      flag_st = 0
      result = []
      array.each do |k, v|
        start_ref = k.split(' ')[5].to_i
        start_query = k.split(' ')[10].to_i
        incr = nil
        end_incr = 0
        gap = 0
        fl_st = 0
        strand = k.split(' ')[9]
        q_size = k.split(' ')[8].to_i
        res_chr = k.split(' ')[7]
        v.each do |val|
          break if flag_st == 1

          if incr.nil?
            end_incr = val[2]
            gap = val[1]
            incr = val[0] + gap
            itval0 = IntervalTree::InclusiveTree.new(start_ref...start_ref + val[0].to_i)
            res1 = itval0.search(coordinate)
            fl_st = start_ref + val[0] + gap
            unless res1.empty?
              if strand == '-'
                res_start = "#{q_size - start_query - (coordinate - start_ref)}"
                flag_st = 1
              else
                res_start = "#{start_query + (coordinate - start_ref)}"
                flag_st = 1
              end
            end
          elsif gap != 0
            itval1 = IntervalTree::InclusiveTree.new(fl_st...fl_st + gap.to_i)
            res2 = itval1.search(coordinate)
            unless res2.empty?
              if strand == '-'
                res_start = "#{q_size - start_query - (coordinate - start_ref)}"
                flag_st = 1
              else
                res_start = "#{start_query + (coordinate - start_ref) + end_incr}"
                flag_st = 1
              end
            end
            fl_st += gap
          else
            incr = val[0].to_i
            if val[0].to_i != 0
              itval2 = IntervalTree::InclusiveTree.new(fl_st...fl_st + val[0].to_i)
              res3 = itval2.search(coordinate)
              unless res3.empty?
                if strand == '-'
                  res_start = "#{q_size - start_query - (coordinate - start_ref)}"
                  flag_st = 1
                else
                  res_start = "#{start_query + (coordinate - start_ref) + end_incr}"
                  flag_st = 1
                end
              end

              fl_st = fl_st + val[0].to_i + gap
              end_incr += val[2].to_i
              gap = val[1].to_i
            else
              fl_st = fl_st + val[0].to_i + gap
              end_incr += val[2].to_i
              gap = val[1].to_i
            end
          end
          gap = val[1].to_i
        end
      end
      "#{res_start.to_i}"
    end # lift
  end # Query
end # LiftOver

# 2Cor3:18
