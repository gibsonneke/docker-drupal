# Generate a salt.txt file when it doesn't exists.
if [ ! -f assets/salt.txt ]
  then
    perl -e '@c=("A".."Z","a".."z",0..9);$p.=$c[rand(scalar @c)] for 1..32; print "$p\n"' > assets/salt.txt
fi
