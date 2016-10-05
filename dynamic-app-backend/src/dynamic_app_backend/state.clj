(ns dynamic-app-backend.state)

(defn add-state [state render]
  (assoc
    render
    :state
    state))
