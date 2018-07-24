require 'json'
require 'net/http'

# Title: Apple Music Plugin for Jekyll
# Author: Young Lee (https://github.com/younglee327)
# Edited on July, 24th 2018 by Young Lee
#   Initial setup
# Description:
#   Given a Apple Music track, user, group, app or set, this will insert an Apple Music HTML5 widget.
#
# Syntax: {% apple-music type id [option=value [option=value [...]]]%}
# type can be one of "tracks", "groups", "users", "favorites", "apps", or "playlists".
# id should be the id of the given resource. A username can also be used in the case of "users" or "favorites"
#
# or:
#
# Syntax: {% apple-music url [option=value [option=value [...]]]%}
# url should be the soudcloud url of the given resource.
# options are:
#
# auto_play=<true|false>
# buying=<true|false>
# download=<true|false>
# sharing=<true|false>
# show_artwork=<true|false>
# show_bpm=<true|false>
# show_comments=<true|false>
# show_playcount=<true|false>
# show_user=<true|false>
# single_active=<true|false>
# start_track=<number>
# color=<hexcode>

module Jekyll
  class AppleMusic < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      #check if an url is given as argument => if yes the new method is used
      if /^http/ =~ markup
        #parsing the "new" way with only pasing the url of the ressource
        if /(?<url>[a-z0-9\/\-\:\.]+)(?:\s+(?<options>.*))?/ =~ markup
          info = retrieve_info(url)
          if info["errors"] == nil
            @type  = info['kind'] + 's'
            @id    = info['id']
            @options = ([] unless options) || options.split(" ")
          else
            @type = :error
            @options = []
          end
        end
      else
        #parsing the "old" way with type and id
        if /(?<type>\w+)\s+(?<id>\d+)(?:\s+(?<options>.*))?/ =~ markup
          @type  = type
          @id    = id
          @options = ([] unless options) || options.split(" ")
        end
      end

      @markup = markup
    end

    def retrieve_info(path)
      response = Net::HTTP.get_response("api.music.apple.com","/resolve.json?client_id=YOUR_CLIENT_ID&url=" + path)
      case response
      when Net::HTTPRedirection then
        location = response['location']
        response = Net::HTTP.get_response(URI(location))
      end
      json = JSON.parse response.body
      return json
    end

    def render(context)
      if @type and @type != :error and @id
        @height = (450 unless @type == 'tracks') || 166
        @resource = (@type unless @type === 'favorites') || 'users'
        @extra = ("" unless @type === 'favorites') || '%2Ffavorites'
        @joined_options = @options.join("&amp;")
        "<iframe width=\"100%\" height=\"#{@height}\" scrolling=\"no\" frameborder=\"no\" src=\"https://w.soundcloud.com/player/?url=https%3A%2F%2Fapi.soundcloud.com%2F#{@resource}%2F#{@id}#{@extra}&amp;#{@joined_options}\"></iframe>"
      elsif @type == :error
        "Error - Sound not available!"
      else
        "Error processing input, expected syntax: {% apple-music type id [options...] %} received: #{@markup}"
      end
    end
  end
end

Liquid::Template.register_tag('apple-music', Jekyll::AppleMusic)

# <iframe allow="autoplay *; encrypted-media *;" frameborder="0" height="150" sandbox="allow-forms allow-popups allow-same-origin allow-scripts allow-top-navigation-by-user-activation" src="https://embed.music.apple.com/us/album/i-might-need-security/1413914842?i=1413914843&app=music" width="660"></iframe>