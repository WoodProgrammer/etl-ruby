require 'open-uri'
require 'nokogiri'
require 'active_record'

ActiveRecord::Base.establish_connection(
    adapter: 'mysql2',
    database: 'deprems',
    username: 'root',
    password: 'abcde',
    host: 'localhost'
)

class Deprems < ActiveRecord::Base


end


def Extract
  doc = Nokogiri::HTML(open("http://www.koeri.boun.edu.tr/scripts/lst4.asp"))
  x = doc.xpath("//pre")
  file = open('temp_data','w+')
  file.write(x)
  file.close()

end

def TransformLoad
  temp_data = open('temp_data','r+')
  i = 0
  temp_data.each do |line|
    i += 1
    if i >=8
      x = line.force_encoding("iso-8859-1").split()
      puts x[0]##date
      begin
        coordinates = x[2]+" "+x[3]
      rescue
        break
      end


        puts x[3]##buyukluk
      Deprems.create(date: x[0],buyukluk: x[6],location: coordinates)
    end
  end
end


Extract()
TransformLoad()