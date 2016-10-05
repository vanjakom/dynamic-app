(ns dynamic-app-backend.server
	(:require compojure.core)
	(:require ring.adapter.jetty)
  (:require ring.middleware.json)
  (:require dynamic-app-backend.core)
  (:require dynamic-app-backend.apps.test)

	(:gen-class))

(defonce server-handle (ref nil))

(def handler
	(compojure.core/routes
		(compojure.core/GET
			"/"
			_
			(fn [request] {:body "hello world!!!\n"}))
    (compojure.core/context
      "/apps"
      []
      (dynamic-app-backend.apps.test/routes))))

(defn start-http-server []
	(let [new-server-handle (ring.adapter.jetty/run-jetty #'handler {:port 7070 :join? false})]
		(dosync (ref-set server-handle new-server-handle))))

(defn stop-http-server []
	(.stop (deref server-handle)))

(defn -main [& args]
	(println "starting http server")
	(start-http-server))
