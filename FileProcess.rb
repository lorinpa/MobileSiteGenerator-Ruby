require "fileutils"

# Copies a set of files, subdirectories and subdirectory contents 
# from the soure locattion represented by srcParentDir, to the location
# represented by destDir.
#
# param srcParentDir represents the location we are copying from.
# param destDir represnets the location we are copyiny to.
#
class FileProcess

    def writeFile(fileName, doc)
        File.open(fileName,"w+") do |f| 
            f.write(doc)
        end
    end

    def createDir(subDir)
        if ! File.directory?(subDir) then
           FileUtils.mkdir(subDir) 
        end
    end

    def copyDir(src,dest) 
        FileUtils.cp_r(src,dest)
    end

    def copySet(srcParentDir, destDir)
        if File.directory?(srcParentDir) then
            Dir.foreach(srcParentDir) {
                |file|
                # Dir.foreach returns "." and "..". Those evaluate to parent directories, 
                # parent directories and files we don't want to copy. So we filter those 
                # patterns out.
                if  (file != "." && file != "..") then
                    srcPath = srcParentDir + "/" + file
                    destPath = destDir + "/" + file
                    FileUtils.cp_r(srcPath,destPath)
                end
            }
        end
    end

end
