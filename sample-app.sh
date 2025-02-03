#!/bin/bash

tempdir=".jenkins_sample"

cleanTemp() {
    if [ -d $tempdir ];  then
        ### We're cleaning the temporary directory
        rm -fr $tempdir
    fi
}

cleanTemp

if [ ! $1 ]; then
    echo "I need at least the name of the container!";
    exit 1
fi;

mkdir $tempdir
mkdir $tempdir/templates
mkdir $tempdir/static

cp sample_app.py $tempdir/.
cp -r templates/* $tempdir/templates/.
cp -r static/* $tempdir/static/.

cat << EOF > $tempdir/Dockerfile
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
EOF

oldDir=$(pwd)

cd $tempdir

docker build -t jenkins-sample:latest .
docker run -t -d -p 5050:5050 --name $1 jenkins-sample:latest
docker ps -a

cd $oldDir


cleanTemp