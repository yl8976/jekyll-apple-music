# Apple Music Plugin for Jekyll

Helps you embed stuff from Apple Music into your Jekyll websites.

## Warning!
Note! This is currently a **work in progress**. The plugin is **not functional** as of yet.

## Setup

1. Add ```apple-music.rb``` to your ```plugin``` folder.
2. Now you can easily embed sounds using the ```type``` and ```id``` or you can simply use the ```url```:

```markdown
# Example 1 (Using type and id)

{% apple-music tracks 55172922 [option=value [option=value [...]]]%}

# Example 1: (Using url)

{% apple-music https://itunes.apple.com/us/album/the-story-of-o-j/1256675529?i=1256675690 [option=value [option=value [...]]]%}
```

## Extra Credits

This plugin was inspired by the [Octopress SoundCloud plugin](https://github.com/soupdiver/octopress-soundcloud) by [Felix Gläske](https://github.com/soupdiver).
