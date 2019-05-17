#!/bin/bash
for IMAGE in 'sentry_cron' 'sentry_worker' 'sentry_web'
do
	NAME=${IMAGE}_1
	#docker run -itd --name $NAME $IMAGE /bin/bash
	docker cp sentryPatch/. $NAME:/usr/local/lib/python2.7/site-packages/sentry/
	docker commit $NAME $IMAGE
done
#docker exec sentry_web_1 sentry config set sentry:version-configured '9.1.1'
