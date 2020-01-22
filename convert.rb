#!/usr/bin/env ruby

require 'fileutils'

DEST_REL_FOLDER = 'Beethoven/Concertos'
# DEST_REL_FOLDER = nil

START_AT = 0

THISFOLDER = File.expand_path(File.dirname(__FILE__))

SOURCES_FOLDER = File.join(THISFOLDER,'sources')
CLAVINO_FOLDER = File.join(THISFOLDER,'clavinova')

FINAL_FOLDER = File.join('/Volumes','MacOSCatalina','CD2Clavinova')
#/Volumes/MacOSCatalina/Users/philippeperret/Music/Musiques_pour_CLAVINOVA/

CLE_USB_PATH = File.join('/Volumes', "NO\ NAME", 'AudioFiles')
ON_CLE_USB = File.exists?(CLE_USB_PATH)

DEST_FOLDER =
  if DEST_REL_FOLDER && File.exists?(FINAL_FOLDER)
    File.join(FINAL_FOLDER,DEST_REL_FOLDER)
  else
    nil
  end

# Si un dossier de destination est défini, on s'assure qu'il existe
if DEST_FOLDER
  `mkdir -p "#{DEST_FOLDER}"`
end

iuseraudio = START_AT
Dir["#{SOURCES_FOLDER}/*.{wav}"].sort.each do |src|
  iuseraudio += 1
  if iuseraudio > 99
    raise "Le numéro est trop grand"
  end

  dst_name = "USERAUDIO#{iuseraudio.to_s.rjust(2,'0')}.WAV"
  dst = File.join(CLAVINO_FOLDER,dst_name)

  `ffmpeg -i "#{src}" "#{dst}" 2> /dev/null`

  src_name = File.basename(src)
  # puts src
  # puts dst
  puts "#{src_name} -> #{dst_name}"

  if DEST_FOLDER
    # Il faut faire la copie sur le disque dur externe
    FileUtils.cp(dst, File.join(DEST_FOLDER,dst_name))
  end

  if ON_CLE_USB
    FileUtils.cp(dst, File.join(CLE_USB_PATH,dst_name))
  end

end
