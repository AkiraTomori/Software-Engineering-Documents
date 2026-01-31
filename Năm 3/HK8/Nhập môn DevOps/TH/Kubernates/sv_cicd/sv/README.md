
helm upgrade --install -n test-0001 --create-namespace ahihi -f app-demo/values.yaml app-demo/

helm upgrade --install -n test-0001 --create-namespace ahihi -f app-demo/values.yaml app-demo/ --set image.repository=ntquan87/nodejs-app-ci-cd --set image.tag=eb41e7a
helm uninstall -n test-0001 ahihi