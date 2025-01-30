#!/bin/bash

mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat << EOF > /tempdir/Dockerfile
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 8000
CMD python /home/myapp/sample_app.py
EOF

cd tempdir
docker build -t sampleapp .
docker run -t -d -p 8000:8000 --name samplerunning sampleapp
docker ps -a 
