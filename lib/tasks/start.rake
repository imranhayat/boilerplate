task :start do 
    p "=> Starting Rails + PG Server "
    Process.exec("sudo service postgresql start \n rails s -p $PORT -b $IP")
end