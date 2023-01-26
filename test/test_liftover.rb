#!/usr/bin/ruby

require 'bio-liftover'

gen1 = 'hg19'
gen2 = 'Hg18'
chr_input = 'chr2'
coord_start = '55000'
coord_end = '55100'

LiftOver::Query.parse_chain_file(gen1, gen2, chr_input, coord_start, coord_end, nil)
