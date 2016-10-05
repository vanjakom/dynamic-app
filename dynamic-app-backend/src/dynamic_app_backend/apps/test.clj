(ns dynamic-app-backend.apps.test
  (:require compojure.core)
  (:require [dynamic-app-backend.core :as core])
  (:require [dynamic-app-backend.ui :as ui])
  (:require [dynamic-app-backend.action :as action])
  (:require [dynamic-app-backend.state :as state]))

(declare index)
(declare login)
(declare login-submit)
(declare login-ok)
(declare login-fail)
(declare exit)

(defn routes []
  (compojure.core/routes
    (core/app-route-maker "test" "index" #'index)
    (core/app-route-maker "test" "login" #'login)
    (core/app-route-maker "test" "login-submit" #'login-submit)
    (core/app-route-maker "test" "exit" #'exit)))

(defn index [state]
  (println state)
  (ui/render
    (ui/list
      (ui/cell "hello world")
      (ui/disclose-cell "login" (action/custom "login"))
      (ui/disclose-cell "exit" (action/exit)))))

(defn login [state]
  (println state)
  (state/add-state
    {:username "test"}
    (ui/render
      (ui/list
        (ui/text-cell "username" nil "username")
        (ui/text-cell "password" nil "password")
        (ui/disclose-cell "login" (action/custom "login-submit"))))))

(defn login-submit [state]
  (let [username (:username state)
        password (:password state)]
    (if (and (= username "test") (= password "test"))
      (login-ok state)
      (login-fail state))))

(defn login-ok [state]
  (println state)
  (ui/render
    (ui/list
      (ui/cell "login successful")
      (ui/disclose-cell "ok" (action/home)))))

(defn login-fail [state]
  (print state)
  (ui/render
    (ui/list
      (ui/cell "login failed")
      (ui/disclose-cell "try again" (action/return)))))

(defn exit [state]
  (action/exit))
