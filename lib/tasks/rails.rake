task :rails do 
    Process.exec("rails s -p $PORT -b $IP")
end