(ns dynamic-app-backend.ui)

(defn render [elements]
  {
    :render elements})

(defn list [& elements]
  elements)

(defn cell [text]
  {:type :label-cell :text text})

(defn text-cell [placeholder text state-var]
  {
    :type :text-cell
    :placeholder placeholder
    :text text
    :state-var state-var})

(defn disclose-cell [text action]
  {:type :disclose-cell :text text :on-disclose action})
