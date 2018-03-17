module ArtistsHelper
  def display_artist(song)
    song.artist.nil? ? link_to("Add Artist", edit_song_path(song)) : link_to(song.artist_name, artist_path(song.artist))
  end

  def artist_select(one, two)
    collection_select :song, :artist_id, Artist.all, :id, :name
  end
end
