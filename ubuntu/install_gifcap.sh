#!/bin/bash

git clone git@github.com:lolilolicon/xrectsel.git

cd xrectsel
sudo ./bootstrap
sudo ./configure
sudo make
sudo make install

sudo add-apt-repository -y ppa:fossfreedom/byzanz
sudo apt-get update
sudo apt-get install -y byzanz

cat > ./gifcap <<"EOF"

#!/bin/bash

# Initialize our own variables:
DELAY=5
TIME=5
OPTIND=1
OUTPUT="$HOME/Desktop/capture_`date +%s`.gif"

while [[ $# > 1 ]]
do
key="$1"
case $key in
    -d|--delay)
    shift
    DELAY="$1"
    ;;
    -o|--output)
    shift
    OUTPUT="$1"
    ;;
    -t|--time)
    shift
    TIME="$1"
    ;;
    *)
    ;;
esac
shift
done

echo "Will record for $TIME seconds after a delay of $DELAY seconds"
echo "Select region..."

# xrectsel from https://github.com/lolilolicon/xrectsel
ARGUMENTS=$(xrectsel "--x=%x --y=%y --width=%w --height=%h") || exit -1

echo Delaying $DELAY seconds. After that, byzanz will start
for (( i=$DELAY; i>0; --i )) ; do
    echo $i
    sleep 1
done

byzanz-record --verbose --delay=0 ${ARGUMENTS} --duration=$TIME $OUTPUT
echo "Saved to $OUTPUT"

EOF

sudo chmod +x ./gifcap
sudo mv ./gifcap /usr/local/bin/gifcap

cd ..
sudo rm -rf ./xrectsel

echo -e "Done.\n"

