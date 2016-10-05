(ns dynamic-app-backend.action)

(defn custom [action]
  {:action action})

(defn home []
  {:action "#home"})

(defn return []
  {:action "#return"})

(defn exit []
  {:action "#exit"})
