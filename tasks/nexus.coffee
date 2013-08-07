"use strict"
Q = require 'q'

module.exports = (grunt) ->
	NexusArtifact = require('../lib/nexus-artifact')(grunt)
	util = require('../lib/util')(grunt)

	# shortcut to underscore
	_ = grunt.util._

	grunt.registerMultiTask 'nexus', 'Download an artifact from nexus', ->
		done = @async()

		# defaults
		options = this.options
			url: ''
			base_path: 'nexus/content/repositories'
			repository: ''
			versionPattern: '%v/%a-%v.%e'

		processes = []

		if !@args.length or _.contains @args, 'fetch'
			_.each options.fetch, (cfg) ->
				# get the base nexus path
				_.extend cfg, NexusArtifact.fromString(cfg.id) if cfg.id

				_.extend cfg, options

				artifact = new NexusArtifact cfg

				processes.push util.download(artifact, cfg.path)

		Q.all(processes).then(() ->
			done()
		).fail (err) ->
			grunt.fail.warn err