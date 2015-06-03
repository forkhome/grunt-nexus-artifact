
module.exports = (grunt) -> class NexusArtifact

  _ = grunt.util._

  # If an ID string is provided, this will return a config object suitable for creation of a NexusArtifact object
  @fromString = (idString) ->
    config = {}

    [config.group_id, config.name, config.ext, config.version, config.classifer] = idString.split(':')
    return config

  constructor: (config) ->
    {@url, @base_path, @repository, @group_id, @name, @version, @ext, @classifer, @versionPattern} = config

  toString: () ->
    [@group_id, @name, @ext, @version, @classifer].join(':')

  buildUrlPath: () ->
    _.compact(_.flatten([
      @url
      @base_path
      @repository
      @group_id.split('.')
      @name
      "#{@version}/"
    ])).join('/')

  buildUrl: () ->
    "#{@buildUrlPath()}#{@buildArtifactUri()}"

  buildArtifactUri: () ->
    @versionPattern.replace /%([avce])/g, ($0, $1) =>
      { a: @name, v: @version, c: @classifer, e: @ext}[$1]