class Song
  attr_accessor :name, :artist, :genre, :musicimporter, :musiclibrarycontroller # readable and writable by the object
  extend Concerns::Findable

  @@all = [] #each class shoudl contain a class variable @@all tha tis set to an empty array

  def initialize(name, artist=nil, genre=nil)
    @name = name # accept a name upon initialization
    self.artist=(artist) if artist != nil
    self.genre=(genre) if genre != nil
  end

  def self.all  #the class variable should be accessible via the class method
    @@all
  end

  def self.destroy_all  #the class should be able to empty its @@all
    @@all.clear
  end

  def save  # the class variable is prepared to store all saveed instances of the class
    @@all << self
  end

  def self.create(song)  #constructor that instantiates an in stance using .new but also invokes #save on that instance, forcing it to persist immediately
    song = self.new(song)
    song.save
    song
  end

  def artist
    @artist
  end

  def artist=(artist)  #adding a song to an artist is done by calling #add_song menthond on an instance of the Artist class
    @artist = artist
    artist.add_song(self)
  end

  def genre
    @genre
  end

  def genre=(genre)
    @genre = genre
    genre.songs << self unless genre.songs.include?(self)
  end

  def self.find_by_name(name)
    @@all.detect do |song|
      song.name == name
    end
  end

  def self.find_or_create_by_name(name)
    self.find_by_name(name) || self.create(name)
  end

  def self.new_from_filename(filename)  # this instantiates a new song object based on a provided filename
    array = filename.split(" - ")

    song_name = array[1]
    artist_name = array[0]
    genre_name = array[2].split(".mp3").join

    artist = Artist.find_or_create_by_name(artist_name)
    genre = Genre.find_or_create_by_name(genre_name)
    self.new(song_name, artist, genre)
  end

  def self.create_from_filename(filename)  #does the same thing as new_from_filename but also saves the newly-created song to the @@all class variable
    self.new_from_filename(filename).save
  end
end