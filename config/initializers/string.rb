class String
  def normalizar
    string = self.strip.gsub(" ","")
    string = self.strip.gsub("'","")
    string = string.gsub("á","a")
    string = string.gsub("é","e")
    string = string.gsub("í","i")
    string = string.gsub("ó","o")
    string = string.gsub("ú","u")
    string = string.gsub("ñ","n")
    string = string.gsub("Á","a")
    string = string.gsub("É","e")
    string = string.gsub("Í","i")
    string = string.gsub("Ó","o")
    string = string.gsub("Ú","u")
    string = string.gsub("Ń","n")   
    string
  end
end