# bio-liftover

[![Build Status](https://secure.travis-ci.org/andreirozanski/bioruby-liftover.png)](http://travis-ci.org/andreirozanski/bioruby-liftover)

A Ruby solution for UCSC LiftOver tool.

Suggestions and help from  Pjotr Prins.

Note: this software is under active development!

## Installation

```sh
gem install bio-liftover
```

## Usage

Inside script:

```ruby
require 'bio-liftover'

```

As bin file:



bio-liftover

Usage:
 bio-liftover ([-v] -c <genome1> <genome2> <chromosome> <start> <end>)
 bio-liftover ([-v] -f <chain_file> -c <genome1> <genome2> <chromosome> <start> <end>)
 bio-liftover -h | --help
 bio-liftover -v | --verbose

Options:
  -h --help  Show this screen.
  -v --verbose  Increase information during run.
  -c --coord  Coordinate as input i.e. hg19,hg18,chr2,55000.
  -f --file  Load local chain file.


The API doc is online. For more code examples see the test files in
the source tree.
        
## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/andreirozanski/bioruby-liftover

The BioRuby community is on IRC server: irc.freenode.org, channel: #bioruby.

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at (http://biogems.info/index.html#bio-liftover)

## Copyright

Copyright (c) 2014 Andrei Rozanski. See LICENSE.txt for further details.

