(ns dynamic-app-backend.core
	(:require compojure.core)
  (:require ring.middleware.json)
  (:require ring.middleware.keyword-params))

(defn app-handler-fn-wrapper [handler-fn]
  (fn [request]
    (println request)
    (let [state (:state (:params request))
          response (handler-fn state)]
    {
      :status 200
      :body response})))

(defn app-route-maker [app target handler-fn]
  (compojure.core/POST
    (str "/" app "/" target)
    _
    (ring.middleware.json/wrap-json-response
			(ring.middleware.json/wrap-json-params
        (ring.middleware.keyword-params/wrap-keyword-params
          (app-handler-fn-wrapper handler-fn))))))
