class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    artist = find_artist
    redirect_to artists_path unless artist
    @song = Song.new
    @song.artist = artist if artist
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    return edit_with_artist if params[:artist_id]
    @song = Song.find_by(id: params[:id])
  end

  def edit_with_artist
    artist = find_artist
    return redirect_to artists_path unless artist

    @song = Song.find_by(id: params[:id])
    redirect_to artist_songs_path(artist) unless @song && @song.artist == artist
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(*%i[title artist_name artist_id])
  end

  def find_artist
    Artist.find_by(id: params[:artist_id]) if params[:artist_id]
  end
end
